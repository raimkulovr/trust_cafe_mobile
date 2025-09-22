part of 'auth_cubit.dart';

final class AuthState extends Equatable {

  final bool isLoggedIn;
  final dynamic error;

  const AuthState({
    this.isLoggedIn = false,
    this.error
  });

  const AuthState.loggedIn({required isProduction}) : this(
    isLoggedIn: true,
  );

  @override
  List<Object?> get props => [
    isLoggedIn,
    error,
  ];

  AuthState copyWith({
    bool? isLoggedIn,
    dynamic error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AuthState{isLoggedIn: $isLoggedIn, error: $error}';
  }
}
