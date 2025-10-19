part of 'bloc.dart';

sealed class LogsEvent {
  final String message;
  const LogsEvent({this.message = ''});
}

final class InitialLogsEvent extends LogsEvent {
  const InitialLogsEvent();
}

final class FetchLogsEvent extends LogsEvent {
  final String token;
  final String? query, state;
  const FetchLogsEvent({required this.token, this.query, this.state});
}

sealed class LogsSuccessEvent extends LogsEvent {
  final String title;
  const LogsSuccessEvent({
    this.title = 'movement_success_title_general',
    super.message = 'movement_success_message_general',
  });
}

sealed class LogsFailEvent extends LogsEvent {
  final String title, reason;
  const LogsFailEvent({
    this.title = 'movement_failed_title_general',
    super.message = 'movement_failed_message_general',
    required this.reason,
  });
}

final class FetchLogsSuccessEvent extends LogsSuccessEvent {
  const FetchLogsSuccessEvent({
    super.title = 'movement_fetch_success_title',
    super.message = 'movement_fetch_success_message',
  });
}

final class FetchLogsFailedEvent extends LogsFailEvent {
  const FetchLogsFailedEvent({
    super.title = 'movement_failed_title_fetch',
    super.message = 'movement_failed_message_fetch',
    required super.reason,
  });
}

final class SetLogsState extends LogsEvent {
  final String? state;
  const SetLogsState({required this.state});
}

final class SetPage extends LogsEvent {
  final int page;
  const SetPage({required this.page});
}

final class LogsPendingEvent extends LogsEvent {
  const LogsPendingEvent();
}
