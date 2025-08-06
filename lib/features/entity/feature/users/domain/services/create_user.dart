import 'package:moh_eam/features/entity/feature/users/data/model/create_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

final class CreateUserService {
  final UsersEntityRepository repo;
  const CreateUserService(this.repo);

  Future<CreateUserResponse> call({
    required String token,
    required CreateUserRequest req,
  }) async {
    return await repo.create(token: token, user: req);
  }
}
