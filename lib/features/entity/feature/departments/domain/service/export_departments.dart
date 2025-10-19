import 'package:moh_eam/features/entity/feature/departments/domain/repositories/department_repo.dart';

class ExportDepartmentsService {
  final DepartmentRepo repo;
  const ExportDepartmentsService(this.repo);
  
  Future<void> call({
    required String token,
    void Function(int recieved, int total)? onProgress,
    void Function()? onError,
    void Function()? onSuccess,
  }) async {
    await repo.export(
      token: token,
      onProgress: onProgress,
      onError: onError,
      onSuccess: onSuccess,
    );
  }
}
