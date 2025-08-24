import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

class SearchInDepartments extends BaseResponse {
  final int max;
  final List<DepartmentModel> departments;

  const SearchInDepartments({
    super.code,
    super.message,
    super.messageKey,
    required this.max,
    required this.departments,
  });

  factory SearchInDepartments.fromJSON(dynamic json) {
    return SearchInDepartments(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      max: json['max'] ?? 1,
      departments: List.generate(
        json['departments'].length,
        (i) => DepartmentModel.fromJson(json['departments'][i]),
      ),
    );
  }
}
