part of 'bloc.dart';

final class LogsState {
  final LogsEvent event;
  final int max, page;
  final String? query, state;
  final List<LogEntity> history;
  const LogsState({
    this.event = const InitialLogsEvent(),
    this.max = 0,
    this.page = 1,
    this.query,
    this.state,
    this.history = const [],
  });

  LogsState copyWith({
    LogsEvent? event,
    int? max,
    int? page,
    String? query,
    String? state,
    List<LogEntity>? history,
  }) {
    return LogsState(
      event: event ?? this.event,
      max: max ?? this.max,
      page: page ?? this.page,
      query: query,
      state: state,
      history: history ?? this.history,
    );
  }

  LogsState resetFilters() {
    return LogsState(
      event: event,
      max: max,
      page: 1,
      query: null,
      state: null,
      history: history,
    );
  }
}
