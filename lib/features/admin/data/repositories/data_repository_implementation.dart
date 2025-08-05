import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/auth/data/models/fetch_roles_model.dart';
import 'package:moh_eam/features/admin/data/models/statistics.dart';
import 'package:moh_eam/features/admin/domain/repositories/data_repository.dart';

final class DataRepositoryImplementation implements DataRepository {
  DataRepositoryImplementation();
  final MOHDioClient _client = MOHDioClient.instance;
  final String version = MohAppConfig.api.version;

  @override
  Future<FetchRolesModel> fetchRoles({required String token}) async {
    return await _client.get(
      endpoint: MohAppConfig.api.roles.replaceAll('\$version', version),
      token: token,
      parser: (json) => FetchRolesModel.fromJson(json),
    );
  }

  @override
  Future<FetchStatistics> fetchStats({required String token}) async {
    return await _client.get(
      token: token,
      endpoint: MohAppConfig.api.devicesStatistics.replaceAll(
        '\$version',
        version,
      ),
      parser: (json) => FetchStatistics.fromJson(json),
    );
  }

  @override
  Future<FetchDepartmentsRootModel> fetchDepts({
    required String token,
    String locale = 'ar',
  }) async {
    return await _client.get(
      endpoint: MohAppConfig.api.departmentsRoot
          .replaceAll('\$version', version)
          .replaceAll('\$lang', locale),
      token: token,
      parser: (json) => FetchDepartmentsRootModel.fromJSON(json),
    );
  }
}
