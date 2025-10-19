import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/logs/domain/entity/log.dart';

final class LogModel {
  final String state;
  final String? actionBy, targetUser, note;
  final String loggedAt;

  const LogModel({
    required this.state,
    this.actionBy,
    this.targetUser,
    this.note,
    required this.loggedAt,
  });

  factory LogModel.fromJSON(dynamic json) {
    return LogModel(
      state: json['state'] ?? 'INVALID_STATE',
      actionBy: json['action_by'],
      targetUser: json['target_user'],
      note: json['note'] ?? "",
      loggedAt: json['logged_at'] ?? 'N/A',
    );
  }

  LogEntity toDomain() {
    return LogEntity(
      state: state,
      actionBy: actionBy,
      targetUser: targetUser,
      note: note,
      loggedAt: loggedAt,
    );
  }
}

final class LogResponse extends BaseResponse {
  final List<LogModel> history;
  final int max;
  const LogResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.max,
    this.history = const [],
  });

  factory LogResponse.fromJSON(dynamic json) {
    return LogResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      max: json['max'] ?? 0,
      history: List.generate(
        json['history'].length,
        (i) => LogModel.fromJSON(json['history'][i]),
      ),
    );
  }

  List<LogEntity> toDomain() {
    return List.generate(history.length, (i) => history[i].toDomain());
  }
}
