import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:user_repository/user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.cookieManager,
    required UserRepository userRepository,
  }) :  _userRepository = userRepository,
        super(const AuthState());

  final CookieManager cookieManager;
  final UserRepository _userRepository;

  String get authUrl => _userRepository.isApiChannelProduction()
      ? 'https://www.trustcafe.io/auth/login'
      : 'https://alpha.wts2.net/auth/login';

  Future<void> authenticateUser() async {
    try {
      final cookies = await cookieManager.getCookies(
          url: WebUri.uri(Uri.parse(authUrl)));

      if (cookies.isEmpty) return;

      final userDataCookie =
          cookies
              .firstWhere((e) => e.name == 'userData')
              .value;

      final tokenDataCookie =
          cookies
              .firstWhere((e) => e.name == 'tokenData')
              .value;

      final userData = jsonDecode(
        Uri.decodeComponent(userDataCookie),
      ) as Map<String, dynamic>;

      final tokenData = jsonDecode(
        Uri.decodeComponent(tokenDataCookie),
      ) as Map<String, dynamic>;

      log('\n\nUSER DATA: $userData\nTOKEN DATA: $tokenData\n\n');

      await _userRepository.authenticateUser(
        userData: userData,
        tokenData: tokenData,
      );

      emit(state.copyWith(isLoggedIn: true));
    } catch (e){
      emit(state.copyWith(error: e));
    }
  }

  @override
  Future<void> close() async {
    log('AUTH CUBIT CLOSED');
    await cookieManager.deleteAllCookies();
    return super.close();
  }

}
