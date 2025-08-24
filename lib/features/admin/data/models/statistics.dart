import 'package:moh_eam/core/data/model/base_response.dart';

class FetchStatistics extends BaseResponse {
  final Map<String, int> statistics;
  final int totalDevices;
  const FetchStatistics({
    super.code,
    super.message,
    super.messageKey = 'general_error_message',
    required this.statistics,
    required this.totalDevices,
  });

  factory FetchStatistics.fromJson(dynamic json) {
    return FetchStatistics(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? 'general_error_message',
      statistics: Map.from(json['stats']),
      totalDevices: json['total_devices'],
    );
  }
}

class FetchUserStatistics extends BaseResponse {
  final int totalUsers;
  const FetchUserStatistics({
    super.code,
    super.message,
    super.messageKey,
    required this.totalUsers,
  });

  factory FetchUserStatistics.fromJSON(dynamic json) {
    return FetchUserStatistics(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? 'general_error_message',
      totalUsers: json['total_users'],
    );
  }
}
