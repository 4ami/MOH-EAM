import 'package:moh_eam/features/roles/data/model/fetch_roles.dart';
import 'package:moh_eam/features/roles/domain/repositories/role_repository.dart';

final class FetchRoleService {
  final RoleRepository repo;
  const FetchRoleService(this.repo);

  Future<FetchRolesResponse> call({required String token}) async {
    return await repo.fetch(token: token);
  }
}
