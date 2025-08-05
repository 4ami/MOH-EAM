part of 'auth_bloc.dart';

sealed class AuthEvent {
  final String message;
  const AuthEvent({this.message = ''});
}

final class InitialAuthEvent extends AuthEvent {
  const InitialAuthEvent();
}

final class AuthPendingEvent extends AuthEvent {
  const AuthPendingEvent();
}

final class UsernameChanged extends AuthEvent {
  final String username;
  const UsernameChanged({required this.username});
}

final class PasswordChanged extends AuthEvent {
  final String password;
  const PasswordChanged({required this.password});
}

final class AuthenticateEvent extends AuthEvent {
  final String locale;
  const AuthenticateEvent({required this.locale});
}

final class AuthenticationSuccess extends AuthEvent {
  const AuthenticationSuccess();
}

final class AuthenticationFailed extends AuthEvent {
  const AuthenticationFailed({required super.message});
}

final class AccessTokenRefreshed extends AuthEvent {
  final String token;
  const AccessTokenRefreshed({required this.token});
}

final class RefreshToken extends AuthEvent {
  const RefreshToken();
}

final class SignoutAuthEvent extends AuthEvent {
  const SignoutAuthEvent();
}
