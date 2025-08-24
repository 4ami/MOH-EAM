part of 'bloc.dart';

final class DepartmentState {
  final DepartmentEvent event;
  final List<DepartmentEntity> children;
  final List<DepartmentEntity> departments;
  final int maxPage;
  const DepartmentState({
    this.event = const DepartmentInitialEvent(),
    this.maxPage =0 ,
    this.children = const [],
    this.departments = const []
  });

  DepartmentState copyWith({
    DepartmentEvent? event,
    List<DepartmentEntity>? children,
    List<DepartmentEntity>? departments,
     int? maxPage,
  }) {
    return DepartmentState(
      event: event ?? this.event,
      children: children ?? this.children,
      departments: departments ?? this.departments,
      maxPage: maxPage ?? this.maxPage
    );
  }
}
