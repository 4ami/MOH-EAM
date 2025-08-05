import 'package:moh_eam/features/entity/feature/users/data/model/fetch_user_details_model.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

class FetchUserDetails {
  final UsersEntityRepository repo;
  const FetchUserDetails(this.repo);

  Future<FetchUserDetailsModel> call({
    required String token,
    required String userId,
  }) async {
    return await repo.fetchUserDetails(userId: userId, token: token);
  }
}
