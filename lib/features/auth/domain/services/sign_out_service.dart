import 'package:moh_eam/features/auth/domain/repositories/auth_repo.dart';

final class SignOutService {
  const SignOutService(this.repo);
  final AuthRepo repo;

  Future<void> call() async {
    await repo.signout();
  }
}
