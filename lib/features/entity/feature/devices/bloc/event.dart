part of 'bloc.dart';

sealed class DeviceEvents {
  final String message;
  const DeviceEvents({this.message = ''});
}

final class InitialDeviceEvent extends DeviceEvents {
  const InitialDeviceEvent();
}

final class DeviceLoadingEvent extends DeviceEvents {
  const DeviceLoadingEvent();
}

final class UpdateDeviceFilters extends DeviceEvents {
  final DeviceFilters filters;
  const UpdateDeviceFilters({required this.filters});
}

final class FetchDevicesEvent extends DeviceEvents {
  final String token;
  const FetchDevicesEvent({required this.token});
}

final class CreateNewDeviceEvent extends DeviceEvents {
  final String token;
  final CreateDeviceRequest deviceRequest;
  const CreateNewDeviceEvent({
    required this.token,
    required this.deviceRequest,
  });
}

sealed class SuccessDeviceEvent extends DeviceEvents {
  final String title;
  const SuccessDeviceEvent({
    this.title = 'device_success_title_general',
    super.message = 'device_success_message_general',
  });
}

sealed class FailedDeviceEvent extends DeviceEvents {
  final String title, reason;
  const FailedDeviceEvent({
    this.title = 'device_failed_title_general',
    super.message = 'device_failed_message_general',
    required this.reason,
  });
}

final class FetchSuccessEvent extends SuccessDeviceEvent {
  const FetchSuccessEvent();
}

final class FetchFailedEvent extends FailedDeviceEvent {
  const FetchFailedEvent({required super.reason});
}

final class CreateSuccessEvent extends SuccessDeviceEvent {
  const CreateSuccessEvent({
    super.title = 'device_success_title_create',
    super.message = 'device_success_message_create',
  });
}

final class CreateFailedEvent extends FailedDeviceEvent {
  const CreateFailedEvent({
    super.title = 'device_failed_title_create',
    super.message = 'device_failed_message_create',
    required super.reason,
  });
}

final class PatchDeviceEvent extends DeviceEvents {
  final String token;
  final PatchDeviceRequest deviceRequest;
  const PatchDeviceEvent({required this.token, required this.deviceRequest});
}

final class DeleteDeviceEvent extends DeviceEvents {
  final String token, id;
  const DeleteDeviceEvent({required this.token, required this.id});
}

final class PatchSuccessEvent extends SuccessDeviceEvent {
  const PatchSuccessEvent({
    super.title = "device_success_title_update",
    super.message = "device_success_message_update",
  });
}

final class PatchFailedEvent extends FailedDeviceEvent {
  const PatchFailedEvent({
    super.title = "device_failed_title_update",
    super.message = "device_failed_message_update",
    required super.reason,
  });
}

final class DeleteSuccessEvent extends SuccessDeviceEvent {
  const DeleteSuccessEvent({
    super.title = "device_success_title_delete",
    super.message = "device_success_message_delete",
  });
}

final class DeleteFailedEvent extends FailedDeviceEvent {
  const DeleteFailedEvent({
    super.title = "device_failed_title_delete",
    super.message = "device_failed_message_delete",
    required super.reason,
  });
}
