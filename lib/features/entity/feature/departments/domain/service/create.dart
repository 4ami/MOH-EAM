import 'package:moh_eam/features/entity/feature/departments/data/model/create_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class CreateDepartmentService {
  final DepartmentRepo repo;

  const CreateDepartmentService(this.repo);

  Future<CreateDepartmentResponse> call({
    required String token,
    required CreateDepartmentModel req,
  }) async {
    return await repo.addNew(token: token, req: req);
  }
}
