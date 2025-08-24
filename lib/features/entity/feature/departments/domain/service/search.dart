import 'package:moh_eam/features/entity/feature/departments/data/model/search.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class SearchInDepartmentService {
  final DepartmentRepo repo;

  const SearchInDepartmentService(this.repo);

  Future<SearchInDepartments> call({
    required String token,
    required String query,
    required String lang,
    required int page,
    required int limit,
  }) async {
    return await repo.search(
      token: token,
      query: query,
      lang: lang,
      page: page,
      limit: limit,
    );
  }
}
