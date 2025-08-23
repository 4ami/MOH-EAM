import 'package:moh_eam/features/entity/feature/users/data/model/patch_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

class PatchUserService {
  final UsersEntityRepository repo;
  const PatchUserService(this.repo);

  Future<PatchUserResponse> call({
    required String token,
    required PatchUserRequest request,
  }) async {
    return await repo.patch(token: token, request: request);
  }
}
