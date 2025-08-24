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

final class DepartmentRequestSubtree extends DepartmentEvent {
  final String token, parent, lang;
  const DepartmentRequestSubtree({
    required this.token,
    required this.parent,
    this.lang = 'ar',
  });
}

final class SearchForDepartmentEvent extends DepartmentEvent {
  final String token, query, lang;
  final int page;
  const SearchForDepartmentEvent({
    required this.token,
    required this.query,
    required this.lang,
    required this.page,
  });
}

final class DepartmentAddNewRequest extends DepartmentEvent {
  const DepartmentAddNewRequest({required this.token, required this.model});

  final String token;
  final CreateDepartmentModel model;
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

sealed class DepartmentSuccessEventSealed extends DepartmentEvent {
  final String title;
  const DepartmentSuccessEventSealed({
    this.title = 'department_success_title_general',
    super.message = 'department_success_message_general',
  });
}

sealed class DepartmentFailedEvent extends DepartmentEvent {
  final String title, reason;
  const DepartmentFailedEvent({
    this.title = 'department_failed_title_general',
    super.message = 'department_failed_message_general',
    required this.reason,
  });
}

final class DepartmentAddedEvent extends DepartmentSuccessEventSealed {
  const DepartmentAddedEvent({
    super.title = 'department_success_title_create',
    super.message = 'department_success_message_create',
    required this.department,
  });
  final DepartmentEntity department;
}

final class DepartmentTreeSuccess extends DepartmentSuccessEventSealed {
  final List<DepartmentEntity> departments;
  const DepartmentTreeSuccess({
    super.title = 'department_success_title_fetch',
    super.message = 'department_success_message_fetch',
    this.departments = const [],
  });
}

final class DepartmentSuccessEvent extends DepartmentSuccessEventSealed {
  const DepartmentSuccessEvent({
    super.title = 'department_success_title_fetch',
    super.message = 'department_success_message_fetch',
  });
}

final class UpdateDepartmentSuccess extends DepartmentSuccessEventSealed {
  const UpdateDepartmentSuccess({
    super.title = 'department_success_title_update',
    super.message = 'department_success_message_update',
  });
}

final class DeleteDepartmentSuccess extends DepartmentSuccessEventSealed {
  const DeleteDepartmentSuccess({
    super.title = 'department_success_title_delete',
    super.message = 'department_success_message_delete',
  });
}

final class SearchInDepartmentSuccess extends DepartmentSuccessEvent {
  const SearchInDepartmentSuccess({
    super.title = 'department_success_title_search',
    super.message = 'department_success_message_search',
  });
}

final class DepartmentFetchFailedEvent extends DepartmentFailedEvent {
  const DepartmentFetchFailedEvent({
    super.title = 'department_failed_title_fetch',
    super.message = 'department_failed_message_fetch',
    required super.reason,
  });
}

final class DepartmentUpdateFailedEvent extends DepartmentFailedEvent {
  const DepartmentUpdateFailedEvent({
    super.title = 'department_failed_title_update',
    super.message = 'department_failed_message_update',
    required super.reason,
  });
}

final class DepartmentDeleteFailedEvent extends DepartmentFailedEvent {
  const DepartmentDeleteFailedEvent({
    super.title = 'department_failed_title_delete',
    super.message = 'department_failed_message_delete',
    required super.reason,
  });
}

final class AddDepartmentFailedEvent extends DepartmentFailedEvent {
  const AddDepartmentFailedEvent({
    super.title = 'department_failed_title_create',
    super.message = 'department_failed_message_create',
    required super.reason,
  });
}

final class SearchInDepartmentFailed extends DepartmentFailedEvent {
  const SearchInDepartmentFailed({
    super.title = 'department_failed_title_search',
    super.message = 'department_failed_message_search',
    required super.reason,
  });
}
