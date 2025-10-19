import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

class ExportUsersService {
  final UsersEntityRepository repo;
  const ExportUsersService(this.repo);

  Future<void> call({
    required String token,
    void Function(int recieved, int total)? onProgress,
    void Function()? onError,
    void Function()? onSuccess,
  }) async {
    await repo.export(
      token: token,
      onProgress: onProgress,
      onError: onError,
      onSuccess: onSuccess,
    );
  }
}
