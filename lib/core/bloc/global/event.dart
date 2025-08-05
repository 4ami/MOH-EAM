part of '../global_bloc_module.dart';

sealed class GlobalDataEvent {
  const GlobalDataEvent({this.message = ''});
  final String message;
}

final class GlobalDataInitialEvent extends GlobalDataEvent {
  const GlobalDataInitialEvent();
}

final class SetGlobalRolesDataEvent extends GlobalDataEvent {
  const SetGlobalRolesDataEvent({required this.roles});
  final List<RoleEntity> roles;
}

final class SetGlobalDepartmentDataEvent extends GlobalDataEvent {
  const SetGlobalDepartmentDataEvent({required this.rootDepartments});
  final List<DepartmentEntity> rootDepartments;
}
