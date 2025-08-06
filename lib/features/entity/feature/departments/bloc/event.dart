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
  const DepartmentFetchRootsEvent({required this.token, this.lang ='ar'});
  final String token, lang;
}

final class DepartmentRequestChildren extends DepartmentEvent {
  final String token, parent;
  const DepartmentRequestChildren({required this.token, required this.parent});
}

final class DepartmentSuccessEvent extends DepartmentEvent {
  const DepartmentSuccessEvent();
}

final class DepartmentFailedEvent extends DepartmentEvent {
  const DepartmentFailedEvent({required super.message});
}
