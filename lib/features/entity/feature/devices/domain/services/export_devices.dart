import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

class ExportDevicesService {
  final DeviceRepo repo;
  const ExportDevicesService(this.repo);

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
