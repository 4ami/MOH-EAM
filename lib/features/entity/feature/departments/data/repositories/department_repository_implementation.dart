import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

final class DepartmentRepoImplementation implements DepartmentRepo {
  DepartmentRepoImplementation();
  final MOHDioClient _client = MOHDioClient.instance;
  final APIConfig _api = MohAppConfig.api;
  final String version = MohAppConfig.api.version;

  @override
  Future<FetchDepartmentChildren> childrenOf({
    required String token,
    required String parent,
    required String lang,
  }) async {
    return _client.get(
      endpoint: _api.departmentChildren
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang)
          .replaceAll('\$department', parent),
      token: token,
      parser: (json) => FetchDepartmentChildren.fromJSON(json),
    );
  }
}
