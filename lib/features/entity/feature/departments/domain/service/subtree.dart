import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_subtree.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

final class Subtree {
  const Subtree(this.repo);
  final DepartmentRepo repo;

  Future<FetchSubtree> call({
    required String token,
    required String parent,
    String lang = 'ar',
  }) async {
    return await repo.subtreeOf(token: token, parent: parent, lang: lang);
  }
}
