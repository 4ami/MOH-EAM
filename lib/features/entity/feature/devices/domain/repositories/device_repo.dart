import 'package:moh_eam/features/entity/feature/devices/data/model/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/delete_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/fetch.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/patch_device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/filters.dart';

abstract interface class DeviceRepo {
  Future<CreateDeviceResponse> create({
    required String token,
    required CreateDeviceRequest req,
  });

  Future<FetchDevicesResponse> fetch({
    required DeviceFilters filters,
    required String token,
  });

  Future<void> export({
    required String token,
    void Function(int recieved, int total)? onProgress,
    void Function()? onError,
    void Function()? onSuccess,
  });

  Future<PatchDeviceResponse> patch({
    required String token,
    required PatchDeviceRequest request,
  });

  Future<DeleteDeviceResponse> delete({
    required String token,
    required String id,
  });
}
