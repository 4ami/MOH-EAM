import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

final class DepartmentChildren {
  final DepartmentRepo repo;
  const DepartmentChildren(this.repo);

  Future<FetchDepartmentChildren> call({
    required String token,
    required String parent,
    String lang = 'ar',
  }) async {
    return await repo.childrenOf(token: token, parent: parent, lang: lang);
  }
}
