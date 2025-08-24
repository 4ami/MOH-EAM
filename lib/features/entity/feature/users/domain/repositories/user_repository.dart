import 'package:moh_eam/features/entity/feature/users/data/model/create_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/delete_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_user_details_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_users_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/patch_user.dart';

abstract interface class UsersEntityRepository {
  Future<FetchUsersModel> fetchUsers({
    String? query,
    required int page,
    required int limit,
    required String token,
    String? locale = 'ar',
    String? role,
    bool? hasDevice,
    String? department,
  });

  Future<FetchUserDetailsModel> fetchUserDetails({
    required String userId,
    required String token,
  });

  Future<CreateUserResponse> create({
    required String token,
    required CreateUserRequest user,
  });

  Future<PatchUserResponse> patch({
    required String token,
    required PatchUserRequest request,
  });

  Future<DeleteUserResponse> delete({
    required String token,
    required String user,
  });
}
