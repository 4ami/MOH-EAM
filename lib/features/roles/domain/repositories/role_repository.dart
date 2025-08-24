import 'package:moh_eam/features/roles/data/model/create_role.dart';
import 'package:moh_eam/features/roles/data/model/delete_response.dart';
import 'package:moh_eam/features/roles/data/model/fetch_roles.dart';

abstract interface class RoleRepository {
  Future<FetchRolesResponse> fetch({required String token});
  Future<CreateRoleResponse> create({
    required String token,
    required CreateRoleRequest request,
  });
  Future<RoleDeleteResponse> delete({
    required String token,
    required String id,
  });
}
