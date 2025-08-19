import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/auth/data/models/fetch_roles_model.dart';
import 'package:moh_eam/features/admin/data/models/statistics.dart';

abstract interface class DataRepository {
  Future<FetchRolesModel> fetchRoles({required String token});
  Future<FetchStatistics> fetchStats({required String token});
  Future<FetchDepartmentsRootModel> fetchDepts({
    required String token,
    String locale = 'ar',
  });
  Future<FetchUserStatistics> fetchUserStats({required String token});
}
