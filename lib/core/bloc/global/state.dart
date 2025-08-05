part of '../global_bloc_module.dart';

final class GlobalDataState {
  const GlobalDataState({
    this.event = const GlobalDataInitialEvent(),
    this.rootDepartments = const [],
    this.roles = const [],
  });

  final GlobalDataEvent event;
  final List<DepartmentEntity> rootDepartments;
  final List<RoleEntity> roles;

  GlobalDataState copyWith({
    GlobalDataEvent? event,
    List<DepartmentEntity>? rootDepartments,
    List<RoleEntity>? roles,
  }) {
    return GlobalDataState(
      event: event ?? this.event,
      rootDepartments: rootDepartments ?? this.rootDepartments,
      roles: roles ?? this.roles,
    );
  }
}
