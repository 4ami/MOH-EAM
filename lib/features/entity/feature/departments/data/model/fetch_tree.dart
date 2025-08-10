import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

class FetchTreeResponse extends BaseResponse {
  final List<DepartmentModel> departments;
  const FetchTreeResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.departments,
  });

  factory FetchTreeResponse.fromJSON(dynamic json) {
    return FetchTreeResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      departments: List.generate(json['departments'].length, (i) {
        return DepartmentModel.fromJson(json['departments'][i]);
      }),
    );
  }
}
