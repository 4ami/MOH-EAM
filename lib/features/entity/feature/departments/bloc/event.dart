part of 'bloc.dart';

sealed class DepartmentEvent {
  final String message;
  const DepartmentEvent({this.message = ''});
}

final class DepartmentInitialEvent extends DepartmentEvent {
  const DepartmentInitialEvent();
}

final class DepartmentLoadingEvent extends DepartmentEvent {
  const DepartmentLoadingEvent();
}

final class DepartmentFetchRootsEvent extends DepartmentEvent {
  const DepartmentFetchRootsEvent({required this.token, this.lang = 'ar'});
  final String token, lang;
}

final class DepartmentRequestChildren extends DepartmentEvent {
  final String token, parent;
  const DepartmentRequestChildren({required this.token, required this.parent});
}

final class DepartmentRequestTree extends DepartmentEvent {
  final String token, id, lang;
  const DepartmentRequestTree({
    required this.token,
    required this.id,
    this.lang = 'ar',
  });
}

final class DepartmentTreeSuccess extends DepartmentEvent {
  final List<DepartmentEntity> departments;
  const DepartmentTreeSuccess({this.departments = const []});
}

final class DepartmentRequestSubtree extends DepartmentEvent {
  final String token, parent, lang;
  const DepartmentRequestSubtree({
    required this.token,
    required this.parent,
    this.lang = 'ar',
  });
}

final class DepartmentAddNewRequest extends DepartmentEvent {
  const DepartmentAddNewRequest({required this.token, required this.model});

  final String token;
  final CreateDepartmentModel model;
}

final class DepartmentAddedEvent extends DepartmentEvent {
  const DepartmentAddedEvent({required this.department});
  final DepartmentEntity department;
}

final class UpdateDepartmentEvent extends DepartmentEvent {
  const UpdateDepartmentEvent({required this.token, required this.request});
  final String token;
  final UpdateDepartmentRequest request;
}

final class DeleteDepartmentEvent extends DepartmentEvent {
  const DeleteDepartmentEvent({
    required this.token,
    required this.departmentId,
  });
  final String token;
  final String departmentId;
}

final class DepartmentSuccessEvent extends DepartmentEvent {
  const DepartmentSuccessEvent();
}

final class UpdateDepartmentSuccess extends DepartmentEvent {
  const UpdateDepartmentSuccess();
}

final class DeleteDepartmentSuccess extends DepartmentEvent {
  const DeleteDepartmentSuccess();
}

final class DepartmentFailedEvent extends DepartmentEvent {
  const DepartmentFailedEvent({required super.message});
}

final class DepartmentUpdateFailedEvent extends DepartmentEvent {
  const DepartmentUpdateFailedEvent({required super.message});
}

final class DepartmentDeleteFailedEvent extends DepartmentEvent {
  const DepartmentDeleteFailedEvent({required super.message});
}

final class AddDepartmentFailedEvent extends DepartmentEvent {
  const AddDepartmentFailedEvent({required super.message});
}
