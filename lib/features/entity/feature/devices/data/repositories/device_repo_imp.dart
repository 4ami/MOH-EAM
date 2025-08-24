import 'package:moh_eam/core/data/sources/remote/moh_api.dart';
import 'package:moh_eam/core/data/sources/remote/moh_dio_client.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/fetch.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/filters.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';

final class DeviceRepoImp implements DeviceRepo {
  final MOHDioClient _client = MOHDioClient.instance;
  final APIConfig _api = MohAppConfig.api;
  final String version = MohAppConfig.api.version;

  @override
  Future<CreateDeviceResponse> create({
    required String token,
    required CreateDeviceRequest req,
  }) async {
    return await _client.post(
      token: token,
      endpoint: _api.deviceCREATE.replaceAll('\$version', version),
      body: req,
      parser: (json) => CreateDeviceResponse.fromJSON(json),
    );
  }

  @override
  Future<FetchDevicesResponse> fetch({
    required DeviceFilters filters,
    required String token,
  }) async {
    return await _client.get(
      token: token,
      queryParams: filters.toQueryParams(),
      endpoint: _api.allDevices.replaceAll('\$version', version),
      parser: (json) => FetchDevicesResponse.fromJSON(json),
    );
  }
}
