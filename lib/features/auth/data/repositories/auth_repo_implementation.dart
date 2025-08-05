import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/auth/data/models/auth_model.dart';
import 'package:moh_eam/features/auth/domain/repositories/auth_repo.dart';

final class AuthRepoImplementation implements AuthRepo {
  AuthRepoImplementation();
  final MOHDioClient _client = MOHDioClient.instance;
  final String version = MohAppConfig.api.version;
  @override
  Future<AuthModel> signin({
    required String username,
    required String password,
    required String locale,
  }) async {
    String endpoint = MohAppConfig.api.authentication
        .replaceAll('\$version', version)
        .replaceAll('\$lang', locale);
    AuthRequest request = AuthRequest(username: username, password: password);
    return await _client.post(
      body: request,
      endpoint: endpoint,
      parser: (json) => AuthModel.fromJSON(json),
    );
  }

  @override
  Future<void> signout() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage
        .delete(key: 'ref_token')
        .catchError(
          (e) => Logger.e(
            'Failed to delete \'referesh token\'',
            tag: 'AuthRepo[signout-service]',
          ),
        );
  }

  @override
  Future<AuthModel> token({required String refToken}) async {
    return await _client.get(
      endpoint: MohAppConfig.api.authToken.replaceAll('\$version', version),
      token: refToken,
      parser: (json) => AuthModel.fromJSON(json),
    );
  }
}
