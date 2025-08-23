import 'package:moh_eam/features/entity/feature/users/data/model/delete_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

class DeleteUserService {
  final UsersEntityRepository repo;
  const DeleteUserService(this.repo);

  Future<DeleteUserResponse> call({
    required String token,
    required String user,
  }) async {
    return await repo.delete(token: token, user: user);
  }
}
