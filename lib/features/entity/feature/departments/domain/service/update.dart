import 'package:moh_eam/features/entity/feature/departments/data/model/update_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class UpdateDepartmentService {
  const UpdateDepartmentService(this.repo);
  final DepartmentRepo repo;

  Future<UpdateDepartmentResponse> call({
    required String token,
    required UpdateDepartmentRequest updatedDepartment,
  }) async {
    return await repo.update(token: token, req: updatedDepartment);
  }
}
