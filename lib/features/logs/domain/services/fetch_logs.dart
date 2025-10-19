import 'package:moh_eam/features/logs/data/model/log_model.dart';
import 'package:moh_eam/features/logs/domain/repository/log_repo.dart';

final class FetchLogsService {
  final LogRepo repo;
  const FetchLogsService(this.repo);

  Future<LogResponse> call({
    required String token,
    int page = 1,
    int limit = 15,
    String? query,
    String? state,
  }) async {
    return await repo.fetch(
      token: token,
      page: page,
      limit: limit,
      query: query,
      state: state,
    );
  }
}
