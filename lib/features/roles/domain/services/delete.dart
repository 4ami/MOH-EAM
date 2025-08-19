import 'package:moh_eam/features/roles/data/model/delete_response.dart';
import 'package:moh_eam/features/roles/domain/repositories/role_repository.dart';

final class RoleDeleteService {
  final RoleRepository repo;
  const RoleDeleteService(this.repo);

  Future<RoleDeleteResponse> call({
    required String token,
    required String id,
  }) async {
    return await repo.delete(token: token, id: id);
  }
}
