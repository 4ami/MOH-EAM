import 'package:moh_eam/features/admin/data/models/global_search.dart';
import 'package:moh_eam/features/admin/domain/repositories/admin_repository.dart';

final class GlobalSearchService {
  final AdminRepository repo;
  const GlobalSearchService(this.repo);

  Future<GlobalSearchResponse> call({
    required String token,
    required String query,
  }) async {
    return await repo.search(token: token, query: query);
  }
}
