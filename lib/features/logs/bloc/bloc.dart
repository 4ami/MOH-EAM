library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/logs/data/model/log_model.dart';
import 'package:moh_eam/features/logs/data/repository/log_repo_imp.dart';
import 'package:moh_eam/features/logs/domain/entity/log.dart';
import 'package:moh_eam/features/logs/domain/services/fetch_logs.dart';

part 'state.dart';
part 'event.dart';

final class LogsBloc extends Bloc<LogsEvent, LogsState> {
  final LogRepoImp _repo = LogRepoImp();
  LogsBloc() : super(const LogsState()) {
    fetch();
    setPage();
    setState();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void fetch() {
    LogResponse? then(LogResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<FetchLogsEvent>((event, emit) async {
      Logger.i("start fetching logs", tag: 'LogsBloc');
      emit(state.copyWith(event: const LogsPendingEvent()));

      String key = '';

      FetchLogsService service = FetchLogsService(_repo);

      LogResponse? res =
          await service(
            token: event.token,
            page: state.page,
            query: event.query,
            state: event.state,
          ).then(then).catchError((e) {
            key = handleError(e);
            return null;
          });
      Logger.i("logs response received", tag: 'LogsBloc');
      if (key.isNotEmpty || res == null) {
        Logger.e("fetch logs failed with key: $key", tag: 'LogsBloc');
        emit(state.copyWith(event: FetchLogsFailedEvent(reason: key)));
        return;
      }

      Logger.i("logs received successfully", tag: 'LogsBloc');

      emit(
        state.copyWith(
          event: const FetchLogsSuccessEvent(),
          history: res.toDomain(),
          max: res.max,
        ),
      );
    });
  }

  void setPage() {
    on<SetPage>((event, emit) {
      emit(state.copyWith(page: event.page, event: event));
    });
  }

  void setState() {
    on<SetLogsState>((event, emit) {
      emit(state.copyWith(state: event.state, event: event));
    });
  }
}
