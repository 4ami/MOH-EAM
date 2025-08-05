library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/data/repositories/department_repository_implementation.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/service/children.dart';

part 'state.dart';
part 'event.dart';

final class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepo _repo = DepartmentRepoImplementation();
  DepartmentBloc() : super(const DepartmentState()) {
    _fetchChildren();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
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
        emit(state.copyWith(event: DepartmentFailedEvent(message: messageKey)));
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
}
