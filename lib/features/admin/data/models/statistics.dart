import 'package:moh_eam/core/data/model/base_response.dart';

class FetchStatistics extends BaseResponse {
  final Map<String, int> statistics;

  const FetchStatistics({
    super.code,
    super.message,
    super.messageKey = 'general_error_message',
    required this.statistics,
  });

  factory FetchStatistics.fromJson(dynamic json) {
    return FetchStatistics(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? 'general_error_message',
      statistics: Map.from(json['stats']),
    );
  }
}
