library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/create_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/delete_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_subtree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_tree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/search.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/update_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/repositories/department_repository_implementation.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/children.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/create.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/delete.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/roots.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/search.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/subtree.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/tree.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/update.dart';

part 'state.dart';
part 'event.dart';

final class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepo _repo = DepartmentRepoImplementation();
  DepartmentBloc() : super(const DepartmentState()) {
    _fetchChildren();
    _fetchRoots();
    _fetchSubtree();
    _addDepartment();
    _updateDepartment();
    _delete();
    _fetchTree();
    _search();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _fetchTree() {
    FetchTreeResponse? then(FetchTreeResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DepartmentRequestTree>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d('Fetching tree structure of ${event.id}', tag: 'DepartmentBloc');

      String key = '';

      DepartmentTreeService service = DepartmentTreeService(_repo);

      FetchTreeResponse? res = await service
          .call(token: event.token, id: event.id, lang: event.lang)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Department tree response received!', tag: 'DepartmentBloc');
      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: DepartmentFetchFailedEvent(reason: key)));
        Logger.e('Fetching tree failed with key: $key', tag: 'DepartmentBloc');
        return;
      }

      Logger.d('Fetching tree success', tag: 'DepartmentBloc');
      emit(
        state.copyWith(
          event: DepartmentTreeSuccess(
            departments: res.departments.map((e) => e.toDomain()).toList(),
          ),
        ),
      );
    });
  }

  void _fetchChildren() {
    FetchDepartmentChildren? then(FetchDepartmentChildren res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DepartmentRequestChildren>((event, emit) async {
      emit(state.copyWith(event: const DepartmentLoadingEvent()));
      Logger.d(
        'Start fetching children of [${event.parent}]',
        tag: 'DepartmentBloc',
      );

      String messageKey = '';

      DepartmentChildren service = DepartmentChildren(_repo);

      FetchDepartmentChildren? childrenModel = await service
          .call(token: event.token, parent: event.parent)
          .then(then)
          .catchError((e) {
            messageKey = handleError(e);
            return null;
          });

      if (messageKey.isNotEmpty || childrenModel == null) {
        Logger.d(
          'Fetching children of [${event.parent}] exit with error: [$messageKey]',
          tag: 'DepartmentBloc',
        );
        emit(
          state.copyWith(event: DepartmentFetchFailedEvent(reason: messageKey)),
        );
        return;
      }

      emit(
        state.copyWith(
          event: const DepartmentSuccessEvent(),
          children: childrenModel.children.map((e) => e.toDomain()).toList(),
        ),
      );
    });
  }

  void _fetchRoots() {
    FetchDepartmentsRootModel? then(FetchDepartmentsRootModel res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DepartmentFetchRootsEvent>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d('Start fetching roots', tag: 'DepartmentBloc');

      String key = '';
      DepartmentRoots service = DepartmentRoots(_repo);

      FetchDepartmentsRootModel? deptsModel = await service
          .call(token: event.token, lang: event.lang)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.d('Fetching roots response received', tag: 'DepartmentBloc');
      if (key.isNotEmpty || deptsModel == null) {
        Logger.e(
          'Fetching roots failed with key [$key]',
          tag: 'DepartmentBloc',
        );
        emit(state.copyWith(event: DepartmentFetchFailedEvent(reason: key)));
        return;
      }
      Logger.i(
        'Fetching roots succeed (${deptsModel.departments.length}/department)',
        tag: 'DepartmentBloc',
      );
      emit(
        state.copyWith(
          event: DepartmentSuccessEvent(),
          departments: deptsModel.departments.map((e) => e.toDomain()).toList(),
        ),
      );
    });
  }

  void _fetchSubtree() {
    FetchSubtree? then(FetchSubtree res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DepartmentRequestSubtree>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d(
        'Start fetching subtree of [${event.parent}]',
        tag: 'DepartmentBloc',
      );

      String key = '';

      Subtree service = Subtree(_repo);

      FetchSubtree? model = await service
          .call(token: event.token, parent: event.parent, lang: event.lang)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.d('Fetching subtree response received', tag: 'DepartmentBloc');
      if (key.isNotEmpty || model == null) {
        Logger.e(
          'Fetching subtree failed with key [$key]',
          tag: 'DepartmentBloc',
        );
        emit(state.copyWith(event: DepartmentFetchFailedEvent(reason: key)));
        return;
      }
      Logger.i(
        'Fetching subtree succeed (${model.departments.length}/department)',
        tag: 'DepartmentBloc',
      );

      emit(
        state.copyWith(
          event: DepartmentSuccessEvent(),
          departments: model.departments.map((d) => d.toDomain()).toList(),
        ),
      );
    });
  }

  void _addDepartment() {
    CreateDepartmentResponse? then(CreateDepartmentResponse res) {
      if (res.code != 201) throw res.messageKey;
      return res;
    }

    on<DepartmentAddNewRequest>((event, emit) async {
      Logger.d('sending new department information', tag: 'DepartmentBloc');
      emit(state.copyWith(event: DepartmentLoadingEvent()));

      String key = '';

      CreateDepartmentService service = CreateDepartmentService(_repo);

      CreateDepartmentResponse? res = await service
          .call(token: event.token, req: event.model)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Add department response recieved', tag: 'DepartmentBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: AddDepartmentFailedEvent(reason: key)));
        Logger.e(
          'Adding new department fail with key: {$key}',
          tag: 'DepartmentBloc',
        );
        return;
      }

      emit(
        state.copyWith(
          event: DepartmentAddedEvent(department: res.department.toDomain()),
        ),
      );

      Logger.w('Department Added Successfully', tag: 'DepartmentBloc');
    });
  }

  void _updateDepartment() {
    UpdateDepartmentResponse? then(UpdateDepartmentResponse res) {
      if (res.code != 201) throw res.messageKey;
      return res;
    }

    on<UpdateDepartmentEvent>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d('Statrt updating department...', tag: 'DepartmentBloc');

      String key = '';

      UpdateDepartmentService service = UpdateDepartmentService(_repo);

      UpdateDepartmentResponse? res = await service
          .call(token: event.token, updatedDepartment: event.request)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Update response received!', tag: 'DepartmentBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: DepartmentUpdateFailedEvent(reason: key)));
        Logger.e('Update department failed with key: $key');
        return;
      }

      emit(state.copyWith(event: UpdateDepartmentSuccess()));
      Logger.d('Update department success', tag: 'DepartmentBloc');
    });
  }

  void _delete() {
    DeleteDepartmentResponse? then(DeleteDepartmentResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DeleteDepartmentEvent>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d(
        'Start deleting department "${event.departmentId}"',
        tag: 'DepartmentBloc',
      );

      String key = '';

      DeleteDepartmentService service = DeleteDepartmentService(_repo);

      DeleteDepartmentResponse? res = await service
          .call(token: event.token, id: event.departmentId)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Delete department response received!', tag: 'DepartmentBloc');

      if (key.isNotEmpty || res == null) {
        state.copyWith(event: DepartmentDeleteFailedEvent(reason: key));
        Logger.e(
          'Delete department failed with key: $key',
          tag: 'DepartmentBloc',
        );
        return;
      }
      state.departments.removeWhere(
        (element) => element.id == event.departmentId,
      );
      emit(state.copyWith(event: DeleteDepartmentSuccess()));
      Logger.d('Delete department success', tag: 'DepartmentBlic');
    });
  }

  void _search() {
    SearchInDepartments? then(SearchInDepartments res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<SearchForDepartmentEvent>((event, emit) async {
      emit(state.copyWith(event: DepartmentLoadingEvent()));
      Logger.d(
        'Searching for ${event.query} in departments',
        tag: 'DepartmentBloc',
      );

      String key = '';

      SearchInDepartmentService service = SearchInDepartmentService(_repo);

      SearchInDepartments? res = await service
          .call(
            token: event.token,
            query: event.query,
            lang: event.lang,
            page: event.page,
            limit: 15,
          )
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Search response received', tag: 'DepartmentBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: SearchInDepartmentFailed(reason: key)));
        Logger.e('Search failed with key: $key', tag: 'DepartmentBloc');
        return;
      }

      Logger.d('Search succeed', tag: 'DepartmentBloc');

      emit(
        state.copyWith(
          event: SearchInDepartmentSuccess(),
          departments: res.departments.map((d) => d.toDomain()).toList(),
          maxPage: res.max,
        ),
      );
    });
  }
}
