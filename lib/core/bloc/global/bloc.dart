part of '../global_bloc_module.dart';

final class GlobalDataBloc extends Bloc<GlobalDataEvent, GlobalDataState> {
  GlobalDataBloc() : super(GlobalDataState()) {
    _setRoles();
    _setRootDepartments();
  }

  void _setRoles() {
    on<SetGlobalRolesDataEvent>((event, emit) {
      Logger.d('Set roles information in global data state', tag: '[GDS]');
      emit(state.copyWith(event: event, roles: event.roles));
    });
  }

  void _setRootDepartments() {
    on<SetGlobalDepartmentDataEvent>((event, emit) {
      Logger.d(
        'Set root departments information in global data state',
        tag: '[GDS]',
      );

      emit(
        state.copyWith(event: event, rootDepartments: event.rootDepartments),
      );
    });
  }
}
