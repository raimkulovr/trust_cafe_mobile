import 'dart:async';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';
import 'package:user_repository/user_repository.dart';

import 'bloc_observer.dart';
import 'routing_table.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  final noSqlStorage = KeyValueStorage();
  final userLocalStorage = UserLocalStorage(noSqlStorage);
  final isProductionInitial = await userLocalStorage.isApiChannelProduction();
  final targetTranslationInitial = await userLocalStorage.getTranslationTarget();
  final appThemeModeInitial = await userLocalStorage.getAppThemeMode();
  final ignoredListInitial = await userLocalStorage.getIgnoredList();
  final imageSizeThresholdInitial = await userLocalStorage.getImageSizeThreshold();

  final app = TrustCafe(
    noSqlStorage: noSqlStorage,
    userLocalStorage: userLocalStorage,
    isProductionInitial: isProductionInitial,
    targetTranslationInitial: targetTranslationInitial,
    appThemeModeInitial: appThemeModeInitial,
    ignoredListInitial: ignoredListInitial,
    imageSizeThresholdInitial: imageSizeThresholdInitial,
  );

  runApp(app);
}

class TrustCafe extends StatefulWidget {
  const TrustCafe({
    required this.isProductionInitial,
    required this.noSqlStorage,
    required this.userLocalStorage,
    required this.targetTranslationInitial,
    required this.appThemeModeInitial,
    required this.ignoredListInitial,
    required this.imageSizeThresholdInitial,
    super.key,
  });

  final bool isProductionInitial;
  final String targetTranslationInitial;
  final String appThemeModeInitial;
  final ({Set<String> branches, Set<String> users}) ignoredListInitial;
  final KeyValueStorage noSqlStorage;
  final UserLocalStorage userLocalStorage;
  final double? imageSizeThresholdInitial;

  @override
  State<TrustCafe> createState() => _TrustCafeState();
}

class _TrustCafeState extends State<TrustCafe> {

  late final TrustCafeApi remoteApi = TrustCafeApi(
      channelSupplier: () => _userRepository.isApiChannelProduction(),
      tokenSupplier: () => _userRepository.getTokenData(),
  );
  late final _userRepository = UserRepository(
      api: remoteApi,
      localStorage: widget.userLocalStorage,
      isProductionInitial: widget.isProductionInitial,
      targetTranslationInitial: widget.targetTranslationInitial,
      appThemeModeInitial: widget.appThemeModeInitial,
      ignoredListInitial: widget.ignoredListInitial,
      imageSizeThresholdInitial: widget.imageSizeThresholdInitial,
  );
  late final _contentRepository = ContentRepository(noSqlStorage: widget.noSqlStorage, api: remoteApi);


  late ThemeMode appThemeMode;
  late final StreamSubscription appThemeModeSubscription;
  @override
  void initState() {
    appThemeMode = _themeModeFromString(widget.appThemeModeInitial);
    appThemeModeSubscription = _userRepository.getAppThemeModeStream().listen((event) {
      final newThemeMode = _themeModeFromString(event);
      if(newThemeMode==appThemeMode) return;
      setState(() {
        appThemeMode=_themeModeFromString(event);
      });
    },);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamBuilder(
        stream: _userRepository.getAppUser(),
        builder: (context, snapshot) {
          final appUser = snapshot.data;
          if(appUser==null)
            return const Center(child: CircularProgressIndicator());

          late final RoutemasterDelegate routerDelegate = CustomRoutemasterDelegate(
            routesBuilder: (context) {
              return RouteMap(
                routes: buildRoutingTable(
                  userRepository: _userRepository,
                  contentRepository: _contentRepository,
                  appUser: appUser,
                ),
              );
            },
          );

          return MaterialApp.router(
            key: ValueKey(appUser.hashCode),
            title: 'TCM',
            themeMode: appThemeMode,
            theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              primary: Colors.blueAccent,
              seedColor: Colors.white,
              surface: Colors.white,
              outline: Colors.blueGrey,
            )),
            darkTheme: ThemeData.from(colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: TcmColors.darkAppBarColor,
            )),
            routerDelegate: routerDelegate,
            routeInformationParser: const RoutemasterParser(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    appThemeModeSubscription.cancel();
    super.dispose();
  }
}

class CustomRoutemasterDelegate extends RoutemasterDelegate {
  CustomRoutemasterDelegate({required super.routesBuilder});

  @override
  Future<bool> popRoute() {
    return pop();
  }
}

ThemeMode _themeModeFromString(String stringThemeData) {
  return switch(stringThemeData) {
    'light'=>ThemeMode.light,
    'dark'=>ThemeMode.dark,
    _=>ThemeMode.system
  };
}