part of 'bloc.dart';

final class DepartmentState {
  final DepartmentEvent event;
  final List<DepartmentEntity> children;
  const DepartmentState({
    this.event = const DepartmentInitialEvent(),
    this.children = const [],
  });

  DepartmentState copyWith({
    DepartmentEvent? event,
    List<DepartmentEntity>? children,
  }) {
    return DepartmentState(
      event: event ?? this.event,
      children: children ?? this.children,
    );
  }
}
