part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthSignUp({
    required this.email,
    required this.password,
  });
}

final class AuthEmailVerificationRequested extends AuthEvent {}

final class AuthCheckEmailVerification extends AuthEvent {}

final class AuthEmailVerified extends AuthEvent {
  final User user;

  AuthEmailVerified({required this.user});
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthLogout extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}
