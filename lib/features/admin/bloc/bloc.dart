library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/auth/data/models/fetch_roles_model.dart';
import 'package:moh_eam/features/admin/data/models/statistics.dart';
import 'package:moh_eam/features/admin/data/repositories/data_repository_implementation.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/admin/domain/repositories/data_repository.dart';
import 'package:moh_eam/features/admin/domain/services/dashboard_service.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

part 'event.dart';
part 'state.dart';

final class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final DataRepository _dataRepository = DataRepositoryImplementation();

  AdminBloc() : super(const AdminState()) {
    _fetchDashboard();
  }

  // This method handles errors that may occur during the fetching of data
  // It logs the error and returns a user-friendly error message
  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _fetchDashboard() {
    List<Object>? then(List<Object> res) {
      if (res.isEmpty) {
        throw '';
      }
      final roles = res[0] as FetchRolesModel;

      if (roles.code != 200) {
        throw roles.messageKey;
      }

      return res;
    }

    // Fetch metadata such as roles, departments, and devices
    // This method can be implemented to fetch data from the repository
    on<AdminFetchDashboardEvent>((event, emit) async {
      Logger.d('Start fetching Admin dashboard.', tag: '[AdminBloc]');
      emit(state.copyWith(event: const AdminDashboardLoadEvent()));

      DashboardService service = DashboardService(repository: _dataRepository);

      String error = '';

      final response =
          await Future.wait([
            service.fetchRoles(event.token),
            service.fetchStats(event.token),
            service.fetchDepts(event.token),
          ]).then(then).catchError((e) {
            error = handleError(e);
            Logger.e(
              'Fetching Admin dashboard exit with error.',
              tag: '[AdminBloc]',
            );
            return null;
          });

      if (error.isNotEmpty || response == null) {
        emit(state.copyWith(event: AdminDashboardFailed(message: error)));
        return;
      }

      final roles = response[0] as FetchRolesModel;
      final stats = response[1] as FetchStatistics;
      final depts = response[2] as FetchDepartmentsRootModel;

      final List<RoleEntity> rolesList = roles.roles
          .map((role) => role.toDomain())
          .toList();

      final List<DepartmentEntity> deptRoots = depts.departments
          .map((d) => d.toDomain())
          .toList();
      Logger.i('Fetching Admin dashboard success.', tag: '[AdminBloc]');
      emit(
        state.copyWith(
          roles: rolesList,
          event: AdminDashboardSuccess(),
          stats: stats.statistics,
          departments: deptRoots,
        ),
      );
    });
  }
}
