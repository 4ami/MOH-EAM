import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/logs/data/model/log_model.dart';
import 'package:moh_eam/features/logs/domain/repository/log_repo.dart';

final class LogRepoImp implements LogRepo {
  LogRepoImp();
  final MOHDioClient _client = MOHDioClient.instance;
  final String _version = MohAppConfig.api.version;
  final APIConfig _api = MohAppConfig.api;

  @override
  Future<LogResponse> fetch({
    required String token,
    int page = 1,
    int limit = 15,
    String? query,
    String? state,
  }) async {
    return await _client.get(
      token: token,
      queryParams: {
        "page": page.toString(),
        "limit": limit.toString(),
        if (query != null) "query": query,
        if (state != null) "state": state,
      },
      endpoint: _api.logs.replaceAll('\$version', _version),
      parser: (json) => LogResponse.fromJSON(json),
    );
  }
}
