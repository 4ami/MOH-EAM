import 'package:moh_eam/features/entity/feature/departments/data/model/delete_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class DeleteDepartmentService {
  const DeleteDepartmentService(this.repo);
  final DepartmentRepo repo;

  Future<DeleteDepartmentResponse> call({
    required String token,
    required String id,
  }) async {
    return await repo.delete(token: token, departmentId: id);
  }
}
