library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/roles/data/model/create_role.dart';
import 'package:moh_eam/features/roles/data/model/delete_response.dart';
import 'package:moh_eam/features/roles/data/model/fetch_roles.dart';
import 'package:moh_eam/features/roles/data/repositories/role_repository_imp.dart';
import 'package:moh_eam/features/roles/domain/repositories/role_repository.dart';
import 'package:moh_eam/features/roles/domain/services/create.dart';
import 'package:moh_eam/features/roles/domain/services/delete.dart';
import 'package:moh_eam/features/roles/domain/services/fetch.dart';

part 'event.dart';
part 'state.dart';

final class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleRepository _repo = RoleRepositoryImp();

  RoleBloc() : super(RoleState()) {
    _fetch();
    _create();
    _delete();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _fetch() {
    FetchRolesResponse? then(FetchRolesResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<FetchRolesEvent>((event, emit) async {
      emit(state.copyWith(event: PendingRoleEvent()));
      Logger.d('Start fetching roles..', tag: 'RoleBloc');
      String key = '';

      FetchRoleService service = FetchRoleService(_repo);

      FetchRolesResponse? res = await service
          .call(token: event.token)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Fetch response recieved', tag: 'RoleBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: FetchRolesFailedEvent(reason: key)));
        Logger.e('Fetch roles failed with key $key', tag: 'RoleBloc');
        return;
      }

      emit(
        state.copyWith(
          event: FetchRolesSuccessEvent(),
          roles: res.roles.map((e) => e.toDomain()).toList(),
        ),
      );
    });
  }

  void _create() {
    CreateRoleResponse? then(CreateRoleResponse res) {
      if (res.code != 201) throw res.messageKey;
      return res;
    }

    on<RoleCreateEvent>((event, emit) async {
      emit(state.copyWith(event: PendingRoleEvent()));
      Logger.d('Creating new role', tag: 'RoleBloc');

      String key = '';

      RoleCreateService service = RoleCreateService(_repo);

      CreateRoleResponse? res = await service
          .call(token: event.token, request: event.request)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Create role response received', tag: 'RoleBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: RoleCreateFailedEvent(reason: key)));
        Logger.e('Create role failed with key $key', tag: 'RoleBloc');
        return;
      }

      emit(state.copyWith(event: RoleCreateSuccessEvent()));
      Logger.d('Create role succeed', tag: 'RoleBloc');
    });
  }

  void _delete() {
    RoleDeleteResponse? then(RoleDeleteResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<RoleDeleteEvent>((event, emit) async {
      emit(state.copyWith(event: PendingRoleEvent()));
      Logger.d('Deleting role[${event.id}]', tag: 'RoleBloc');

      String key = '';

      RoleDeleteService service = RoleDeleteService(_repo);

      RoleDeleteResponse? res = await service
          .call(token: event.token, id: event.id)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Delete role response received', tag: 'RoleBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: RoleDeleteFailedEvent(reason: key)));
        Logger.e('Delete role field with key $key', tag: 'RoleBloc');
        return;
      }
      Logger.d('Delete role succeed', tag: 'RoleBloc');
      emit(state.copyWith(event: RoleDeleteSuccessEvent()));
    });
  }
}
