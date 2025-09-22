import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:user_repository/user_repository.dart';
import './auth_cubit.dart';

//TODO: progress indicator for when WebView is initializing
class AuthScreen extends StatelessWidget {
  const AuthScreen({
    required this.userRepository, super.key,
  });

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(cookieManager: CookieManager.instance(), userRepository: userRepository),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {

  int? progress;

  Widget _buildWebView(BuildContext context, String authUrl) {
    return InAppWebView(
      onProgressChanged: (controller, progress) {
        this.progress = progress == 100 ? null : progress;
        setState(() {});
      },
      onLoadStop: (controller, url) async {
        String js = """
          (function() {
            var header = document.querySelector('header');
            if (header) {
              header.style.display = 'none';
            }
          })();
        """;
        await controller.evaluateJavascript(source: js);
      },
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(authUrl))),
      onUpdateVisitedHistory: (controller, url, isReload) {
        if(!url.toString().startsWith(authUrl)){
          context.read<AuthCubit>().authenticateUser();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.isLoggedIn){
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocBuilder<AuthCubit,AuthState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _buildWebView(context, context.read<AuthCubit>().authUrl),
                  if(progress!=null) Center(child: SizedBox.square(
                      dimension: 50,
                      child: CircularProgressIndicator(value: progress!/100,))),
                ],);
            }
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}