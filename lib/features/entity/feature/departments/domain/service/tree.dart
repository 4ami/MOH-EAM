import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_tree.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class DepartmentTreeService {
  final DepartmentRepo repo;
  const DepartmentTreeService(this.repo);

  Future<FetchTreeResponse> call({
    required String token,
    String lang = 'ar',
    required String id,
  }) async {
    return await repo.tree(token: token, lang: lang, id: id);
  }
}
