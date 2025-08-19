import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/roles/data/model/create_role.dart';
import 'package:moh_eam/features/roles/data/model/delete_response.dart';
import 'package:moh_eam/features/roles/data/model/fetch_roles.dart';
import 'package:moh_eam/features/roles/domain/repositories/role_repository.dart';

final class RoleRepositoryImp implements RoleRepository {
  final MOHDioClient _client = MOHDioClient.instance;
  final APIConfig _api = MohAppConfig.api;
  final String version = MohAppConfig.api.version;
  RoleRepositoryImp();

  @override
  Future<FetchRolesResponse> fetch({required String token}) async {
    return await _client.get(
      token: token,
      endpoint: _api.roles.replaceAll('\$version', version),
      parser: (json) => FetchRolesResponse.fromJSON(json),
    );
  }

  @override
  Future<CreateRoleResponse> create({
    required String token,
    required CreateRoleRequest request,
  }) async {
    return await _client.post(
      token: token,
      endpoint: _api.roles.replaceAll('\$version', version),
      body: request,
      parser: (json) => CreateRoleResponse.fromJSON(json),
    );
  }

  @override
  Future<RoleDeleteResponse> delete({
    required String token,
    required String id,
  }) async {
    return _client.delete(
      token: token,
      endpoint: _api.roleDELETE
          .replaceAll('\$version', version)
          .replaceAll('\$role', id),
      parser: (json) => RoleDeleteResponse.fromJSON(json),
    );
  }
}
