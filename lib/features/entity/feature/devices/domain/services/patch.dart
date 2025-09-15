import 'package:moh_eam/features/entity/feature/devices/data/model/patch_device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

class PatchDeviceService {
  final DeviceRepo repo;
  const PatchDeviceService(this.repo);

  Future<PatchDeviceResponse> call({
    required String token,
    required PatchDeviceRequest req,
  }) async {
    return await repo.patch(token: token, request: req);
  }
}
