import 'package:moh_eam/features/guest/data/model/profile_model.dart';

abstract interface class ProfileRepo {
  Future<ProfileModel> getProfile({required String token});
}
