import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

final class FetchSubtree extends BaseResponse {
  const FetchSubtree({
    super.code,
    super.message,
    super.messageKey,
    this.departments = const [],
  });

  final List<DepartmentModel> departments;

  factory FetchSubtree.fromJSON(dynamic json) {
    return FetchSubtree(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      departments: List.generate(
        json['departments'].length,
        (i) => DepartmentModel.fromJson(json['departments'][i]),
      ),
    );
  }
}
