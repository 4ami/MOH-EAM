import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';

abstract interface class DepartmentRepo {
  Future<FetchDepartmentChildren> childrenOf({
    required String token,
    required String parent,
    required String lang,
  });
}
