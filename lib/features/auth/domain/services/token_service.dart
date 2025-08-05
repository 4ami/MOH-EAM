import 'package:moh_eam/features/auth/data/models/auth_model.dart';
import 'package:moh_eam/features/auth/domain/repositories/auth_repo.dart';

final class TokenService {
  final AuthRepo repo;
  const TokenService(this.repo);

  Future<AuthModel> call({required String refToken}) async {
    return await repo.token(refToken: refToken);
  }
}
