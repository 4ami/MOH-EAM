import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';

abstract interface class DepartmentRepo {
  Future<FetchDepartmentChildren> childrenOf({
    required String token,
    required String parent,
    required String lang,
  });

  Future<FetchDepartmentsRootModel> roots({
    required String token,
    String lang = 'ar',
  });
}
