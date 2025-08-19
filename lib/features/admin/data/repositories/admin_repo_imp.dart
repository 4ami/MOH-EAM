import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/admin/data/models/global_search.dart';
import 'package:moh_eam/features/admin/domain/repositories/admin_repository.dart';

final class AdminRepoImp implements AdminRepository {
  final MOHDioClient _client = MOHDioClient.instance;
  final APIConfig _api = MohAppConfig.api;
  final String _version = MohAppConfig.api.version;

  AdminRepoImp();

  @override
  Future<GlobalSearchResponse> search({
    required String token,
    required String query,
  }) async {
    return await _client.get(
      token: token,
      queryParams: {"query": Uri.encodeQueryComponent(query)},
      endpoint: _api.globalSearch.replaceAll('\$version', _version),
      parser: (json) => GlobalSearchResponse.fromJSON(json),
    );
  }
}
