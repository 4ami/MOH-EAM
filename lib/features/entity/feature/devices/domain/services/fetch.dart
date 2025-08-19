import 'package:moh_eam/features/entity/feature/devices/data/model/fetch.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/filters.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

class FetchDevicesService {
  final DeviceRepo repo;
  const FetchDevicesService(this.repo);

  Future<FetchDevicesResponse> call({
    required String token,
    required DeviceFilters filters,
  }) async {
    return await repo.fetch(filters: filters, token: token);
  }
}
