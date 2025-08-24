import 'package:moh_eam/features/entity/feature/devices/data/model/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/fetch.dart';
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
}
