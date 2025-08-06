import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

final class DepartmentRoots {
  final DepartmentRepo repo;
  const DepartmentRoots(this.repo);

  Future<FetchDepartmentsRootModel> call({
    required String token,
    String lang = 'ar',
  }) async {
    return await repo.roots(token: token, lang: lang);
  }
}
