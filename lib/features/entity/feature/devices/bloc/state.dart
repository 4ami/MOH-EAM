part of 'bloc.dart';

final class DeviceState {
  final List<DeviceEntity> devices;
  final DeviceEvents event;
  final DeviceFilters filters;
  final int max;

  const DeviceState({
    this.devices = const [],
    this.max = 0,
    this.filters = const DeviceFilters(),
    this.event = const InitialDeviceEvent(),
  });

  DeviceState copyWith({
    List<DeviceEntity>? devices,
    int? max,
    DeviceFilters? filters,
    DeviceEvents? event,
  }) {
    return DeviceState(
      devices: devices ?? this.devices,
      max: max ?? this.max,
      filters: filters ?? this.filters,
      event: event ?? this.event,
    );
  }
}
