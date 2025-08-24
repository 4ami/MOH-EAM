import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/auth/data/models/fetch_roles_model.dart';
import 'package:moh_eam/features/admin/data/models/statistics.dart';
import 'package:moh_eam/features/admin/domain/repositories/data_repository.dart';

final class DashboardService {
  final DataRepository repository;
  const DashboardService({required this.repository});

  Future<FetchRolesModel> fetchRoles(String token) async {
    return await repository.fetchRoles(token: token);
  }

  Future<FetchStatistics> fetchStats(String token) async {
    return await repository.fetchStats(token: token);
  }

  Future<FetchDepartmentsRootModel> fetchDepts(
    String token, {
    String locale = 'ar',
  }) async {
    return await repository.fetchDepts(token: token, locale: locale);
  }

  Future<FetchUserStatistics> fetchUserStats(String token) async {
    return await repository.fetchUserStats(token: token);
  }
}
