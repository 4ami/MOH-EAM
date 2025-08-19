import 'package:moh_eam/features/admin/data/models/global_search.dart';

abstract interface class AdminRepository {
  Future<GlobalSearchResponse> search({
    required String token,
    required String query,
  });
}
