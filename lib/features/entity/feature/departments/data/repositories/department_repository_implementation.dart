import 'package:dio/dio.dart';
import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/create_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/delete_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_subtree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_tree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/search.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/update_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

final class DepartmentRepoImplementation implements DepartmentRepo {
  DepartmentRepoImplementation();
  final MOHDioClient _client = MOHDioClient.instance;
  final APIConfig _api = MohAppConfig.api;
  final String version = MohAppConfig.api.version;

  @override
  Future<FetchDepartmentChildren> childrenOf({
    required String token,
    required String parent,
    required String lang,
  }) async {
    return _client.get(
      endpoint: _api.departmentChildren
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang)
          .replaceAll('\$department', parent),
      token: token,
      parser: (json) => FetchDepartmentChildren.fromJSON(json),
    );
  }

  @override
  Future<FetchDepartmentsRootModel> roots({
    required String token,
    String lang = 'ar',
  }) async {
    return await _client.get(
      token: token,
      endpoint: _api.departmentsRoot
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang),
      parser: (json) => FetchDepartmentsRootModel.fromJSON(json),
    );
  }

  @override
  Future<FetchSubtree> subtreeOf({
    required String token,
    required String parent,
    String lang = 'ar',
  }) async {
    return await _client.get(
      token: token,
      endpoint: _api.departmentSubtree
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang)
          .replaceAll('\$department', parent),
      parser: (json) => FetchSubtree.fromJSON(json),
    );
  }

  @override
  Future<CreateDepartmentResponse> addNew({
    required String token,
    required CreateDepartmentModel req,
  }) async {
    return await _client.post(
      endpoint: _api.departmentCREATE.replaceAll('\$version', version),
      token: token,
      body: req,
      parser: (json) => CreateDepartmentResponse.fromJSON(json),
    );
  }

  @override
  Future<UpdateDepartmentResponse> update({
    required String token,
    required UpdateDepartmentRequest req,
  }) async {
    return await _client.put(
      token: token,
      endpoint: _api.departmentUPDATE.replaceAll('\$version', version),
      body: req,
      parser: (json) => UpdateDepartmentResponse.fromJSON(json),
    );
  }

  @override
  Future<DeleteDepartmentResponse> delete({
    required String token,
    required String departmentId,
  }) async {
    return await _client.delete(
      token: token,
      endpoint: _api.departmentDELETE
          .replaceAll('\$version', version)
          .replaceAll('\$department', departmentId),
      parser: (json) => DeleteDepartmentResponse.fromJSON(json),
    );
  }

  @override
  Future<FetchTreeResponse> tree({
    required String token,
    required String lang,
    required String id,
  }) async {
    return await _client.get(
      token: token,
      endpoint: _api.departmentTree
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang)
          .replaceAll('\$department', id),
      parser: (json) => FetchTreeResponse.fromJSON(json),
    );
  }

  @override
  Future<SearchInDepartments> search({
    required String token,
    required String query,
    required String lang,
    required int page,
    required int limit,
  }) async {
    return await _client.get(
      token: token,
      queryParams: {
        "query": Uri.encodeQueryComponent(query),
        "page": Uri.encodeQueryComponent(page.toString()),
        "limit": Uri.encodeQueryComponent(limit.toString()),
      },
      endpoint: _api.departmentSEARCH
          .replaceAll('\$version', version)
          .replaceAll('\$lang', lang),
      parser: (json) => SearchInDepartments.fromJSON(json),
    );
  }


  @override
  Future<void> export({
    required String token,
    void Function(int recieved, int total)? onProgress,
    void Function()? onError,
    void Function()? onSuccess,
  }) async {
    await _client.download(
      endpoint: MohAppConfig.api.exportDepartments.replaceAll('\$version', version),
      token: token,
      onProgress: onProgress,
      options: Options(responseType: ResponseType.bytes),
      onError: onError,
      onSuccess: onSuccess
    );
  }
}
