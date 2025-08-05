part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState({required this.event});
  final AuthEvent event;
  AuthState copyWith({AuthEvent? event});
}

final class UnAuthenticatedState extends AuthState {
  const UnAuthenticatedState({
    super.event = const InitialAuthEvent(),
    this.username = '',
    this.password = '',
  });
  final String username, password;
  @override
  UnAuthenticatedState copyWith({
    AuthEvent? event,
    String? username,
    String? password,
  }) {
    return UnAuthenticatedState(
      event: event ?? this.event,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

final class AuthenticatedState extends AuthState {
  const AuthenticatedState({
    super.event = const InitialAuthEvent(),
    required this.user,
    this.token = '',
  });

  final String token;
  final UserEntity user;

  @override
  AuthenticatedState copyWith({AuthEvent? event, String? token, UserEntity? user}) {
    return AuthenticatedState(
      token: token ?? this.token,
      user: user ?? this.user,
      event: event ?? super.event,
    );
  }
}
