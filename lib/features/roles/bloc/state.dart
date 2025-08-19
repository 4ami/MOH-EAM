part of 'bloc.dart';

final class RoleState {
  final RoleEvent event;
  final List<RoleEntity> roles;
  const RoleState({
    this.event = const InitialRoleEvent(),
    this.roles = const [],
  });

  RoleState copyWith({RoleEvent? event, List<RoleEntity>? roles}) {
    return RoleState(event: event ?? this.event, roles: roles ?? this.roles);
  }
}
