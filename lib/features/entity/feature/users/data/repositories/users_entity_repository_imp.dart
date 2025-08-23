import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/create_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/delete_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_user_details_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_users_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/patch_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';

final class UsersEntityRepositoryImp implements UsersEntityRepository {
  UsersEntityRepositoryImp();
  final MOHDioClient _client = MOHDioClient.instance;
  final String version = MohAppConfig.api.version;

  @override
  Future<FetchUsersModel> fetchUsers({
    String? query,
    required String token,
    required int page,
    required int limit,
    String? locale = 'ar',
    String? role,
    bool? hasDevice,
    String? department,
  }) async {
    return await _client.get<FetchUsersModel>(
      endpoint: MohAppConfig.api.usersFetch.replaceAll('\$version', version),
      token: token,
      queryParams: {
        if (query != null) "query": Uri.encodeQueryComponent(query),
        "page": Uri.encodeQueryComponent(page.toString()),
        "limit": Uri.encodeQueryComponent(limit.toString()),
        "locale": Uri.encodeQueryComponent(locale.toString()),
        if (role != null) "role": Uri.encodeQueryComponent(role),
        if (hasDevice != null)
          "has_device": Uri.encodeQueryComponent(hasDevice.toString()),
        if (department != null)
          "department": Uri.encodeQueryComponent(department),
      },
      parser: (json) => FetchUsersModel.fromJSON(json),
    );
  }

  @override
  Future<FetchUserDetailsModel> fetchUserDetails({
    required String userId,
    required String token,
  }) async {
    return await _client.get<FetchUserDetailsModel>(
      endpoint: MohAppConfig.api.userDetails
          .replaceAll('\$version', version)
          .replaceAll('\$user', userId),
      token: token,
      parser: (json) => FetchUserDetailsModel.fromJSON(json),
    );
  }

  @override
  Future<CreateUserResponse> create({
    required String token,
    required CreateUserRequest user,
  }) async {
    return await _client.post(
      endpoint: MohAppConfig.api.userCREATE.replaceAll('\$version', version),
      body: user,
      token: token,
      parser: (json) => CreateUserResponse.fromJSON(json),
    );
  }

  @override
  Future<PatchUserResponse> patch({
    required String token,
    required PatchUserRequest request,
  }) async {
    return await _client.patch(
      token: token,
      endpoint: MohAppConfig.api.userUPDATE.replaceAll('\$version', version),
      body: request,
      parser: (json) => PatchUserResponse.fromJSON(json),
    );
  }

  @override
  Future<DeleteUserResponse> delete({
    required String token,
    required String user,
  }) async {
    return await _client.delete(
      token: token,
      endpoint: MohAppConfig.api.userDELETE
          .replaceAll('\$version', version)
          .replaceAll('\$user', user),
      parser: (json) => DeleteUserResponse.fromJSON(json),
    );
  }
}
