import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/delete_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/fetch.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/patch_device.dart';
import 'package:moh_eam/features/entity/feature/devices/data/repositories/device_repo_imp.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/filters.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/repositories/device_repo.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/services/create.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/services/delete.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/services/fetch.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/services/patch.dart';

part 'state.dart';
part 'event.dart';

final class DeviceBloc extends Bloc<DeviceEvents, DeviceState> {
  final DeviceRepo _repo = DeviceRepoImp();
  DeviceBloc() : super(DeviceState()) {
    _updateFilters();
    _fetch();
    _create();
    _patch();
    _delete();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _updateFilters() {
    on<UpdateDeviceFilters>((event, emit) {
      emit(state.copyWith(filters: event.filters));
    });
  }

  void _fetch() {
    FetchDevicesResponse? then(FetchDevicesResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<FetchDevicesEvent>((event, emit) async {
      emit(state.copyWith(event: DeviceLoadingEvent()));
      Logger.d('Fetching devices...', tag: 'DeviceBloc');

      String key = '';

      FetchDevicesService service = FetchDevicesService(_repo);

      FetchDevicesResponse? res = await service
          .call(token: event.token, filters: state.filters)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Fetch devices response received', tag: 'DeviceBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: FetchFailedEvent(reason: key)));
        Logger.e('Fetching device failed with key: $key');
        return;
      }

      Logger.d('Fetch devices success', tag: 'DeviceBloc');
      emit(
        state.copyWith(
          devices: res.devices.map((d) => d.toDomain()).toList(),
          max: res.max,
          event: FetchSuccessEvent(),
        ),
      );
    });
  }

  void _create() {
    CreateDeviceResponse? then(CreateDeviceResponse res) {
      if (res.code != 201) throw res.messageKey;
      return res;
    }

    on<CreateNewDeviceEvent>((event, emit) async {
      emit(state.copyWith(event: DeviceLoadingEvent()));
      Logger.d('Start adding new device', tag: 'DeviceBloc');

      String key = '';

      CreateDeviceService service = CreateDeviceService(_repo);

      CreateDeviceResponse? res = await service
          .call(token: event.token, req: event.deviceRequest)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Create device response received', tag: 'DeviceBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: CreateFailedEvent(reason: key)));
        Logger.e('Creating device failed with key: $key', tag: 'DeviceBloc');
        return;
      }

      Logger.d('Device created successfully', tag: 'DeviceBloc');
      emit(state.copyWith(event: CreateSuccessEvent()));
    });
  }

  void _patch() {
    PatchDeviceResponse? then(PatchDeviceResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<PatchDeviceEvent>((event, emit) async {
      emit(state.copyWith(event: DeviceLoadingEvent()));
      Logger.d(
        'Start patching device [${event.deviceRequest.device.id}]',
        tag: 'DeviceBloc',
      );

      String key = '';

      PatchDeviceService service = PatchDeviceService(_repo);

      PatchDeviceResponse? res =
          await service(
            token: event.token,
            req: event.deviceRequest,
          ).then(then).catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Patch device response received', tag: 'DeviceBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: PatchFailedEvent(reason: key)));
        Logger.e('Patch device failed with key: $key', tag: 'DeviceBloc');
        return;
      }

      Logger.d('Device patched successfully', tag: 'DeviceBloc');
      emit(state.copyWith(event: PatchSuccessEvent()));
    });
  }

  void _delete() {
    DeleteDeviceResponse? then(DeleteDeviceResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DeleteDeviceEvent>((event, emit) async {
      emit(state.copyWith(event: DeviceLoadingEvent()));
      Logger.d('Start deleting device [${event.id}]', tag: 'DeviceBloc');

      String key = '';

      DeleteDeviceService service = DeleteDeviceService(_repo);

      DeleteDeviceResponse? res =
          await service(token: event.token, id: event.id).then(then).catchError(
            (e) {
              key = handleError(e);
              return null;
            },
          );

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: DeleteFailedEvent(reason: key)));
        Logger.e('Deleting device failed with key: $key', tag: 'DeviceBloc');
        return;
      }

      Logger.d('Device deleted successfully', tag: 'DeviceBloc');
      emit(state.copyWith(event: DeleteSuccessEvent()));
    });
  }
}
