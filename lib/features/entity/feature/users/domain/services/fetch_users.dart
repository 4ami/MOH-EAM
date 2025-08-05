import 'package:moh_eam/features/entity/feature/users/data/model/fetch_users_model.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

class FetchUsers {
  final UsersEntityRepository repo;
  const FetchUsers(this.repo);

  Future<FetchUsersModel> call({
    String? query,
    required int page,
    required int limit,
    required String token,
    String? locale = 'ar',
    String? role,
    bool? hasDevice,
    String? department,
  }) async {
    return await repo.fetchUsers(
      query: query,
      page: page,
      limit: limit,
      token: token,
      role: role,
      locale: locale,
      hasDevice: hasDevice,
      department: department,
    );
  }
}
