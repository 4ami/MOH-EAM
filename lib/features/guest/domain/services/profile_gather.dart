import 'package:moh_eam/features/guest/data/model/profile_model.dart';
import 'package:moh_eam/features/guest/domain/repository/profile_repo.dart';

class ProfileGatherService {
  final ProfileRepo repo;
  const ProfileGatherService(this.repo);

  Future<ProfileModel> call({required String token}) async {
    return await repo.getProfile(token: token);
  }
}
