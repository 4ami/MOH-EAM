import 'package:moh_eam/features/entity/feature/devices/data/model/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

final class CreateDeviceService {
  final DeviceRepo repo;
  const CreateDeviceService(this.repo);

  Future<CreateDeviceResponse> call({
    required String token,
    required CreateDeviceRequest req,
  }) async {
    return await repo.create(token: token, req: req);
  }
}
