import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/guest/data/model/profile_model.dart';
import 'package:moh_eam/features/guest/domain/repository/profile_repo.dart';

final class ProfileRepoImp implements ProfileRepo {
  ProfileRepoImp();
  final MOHDioClient _client = MOHDioClient.instance;
  final String _version = MohAppConfig.api.version;
  final APIConfig _api = MohAppConfig.api;

  @override
  Future<ProfileModel> getProfile({required String token}) async {
    return await _client.get(
      token: token,
      endpoint: _api.profile.replaceAll('\$version', _version),
      parser: (json) => ProfileModel.fromJSON(json),
    );
  }
}
