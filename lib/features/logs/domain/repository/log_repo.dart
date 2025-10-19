import 'package:moh_eam/features/logs/data/model/log_model.dart';

abstract interface class LogRepo {
  Future<LogResponse> fetch({
    required String token,
    int page = 1,
    int limit = 15,
    String? query,
    String? state,
  });
}
