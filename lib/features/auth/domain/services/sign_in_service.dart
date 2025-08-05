import 'package:moh_eam/features/auth/data/models/auth_model.dart';
import 'package:moh_eam/features/auth/domain/repositories/auth_repo.dart';

final class SignInService {
  final AuthRepo repo;
  const SignInService(this.repo);

  Future<AuthModel> call({
    required String username,
    required String password,
    required String locale,
  }) async {
    return await repo.signin(username: username, password: password, locale: locale);
  }
}
