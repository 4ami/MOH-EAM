import 'package:moh_eam/features/roles/data/model/create_role.dart';
import 'package:moh_eam/features/roles/domain/repositories/role_repository.dart';

final class RoleCreateService {
  final RoleRepository repo;
  const RoleCreateService(this.repo);

  Future<CreateRoleResponse> call({
    required String token,
    required CreateRoleRequest request,
  }) async {
    return await repo.create(token: token, request: request);
  }
}
