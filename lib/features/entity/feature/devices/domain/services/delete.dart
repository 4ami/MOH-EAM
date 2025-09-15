import 'package:moh_eam/features/entity/feature/devices/data/model/delete_device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

class DeleteDeviceService {
  final DeviceRepo repo;
  const DeleteDeviceService(this.repo);

  Future<DeleteDeviceResponse> call({
    required String token,
    required String id,
  }) async {
    return await repo.delete(token: token, id: id);
  }
}
