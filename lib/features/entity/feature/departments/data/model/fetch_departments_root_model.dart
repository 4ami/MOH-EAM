import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

class FetchDepartmentsRootModel extends BaseResponse {
  final List<DepartmentModel> departments;

  const FetchDepartmentsRootModel({
    super.code,
    super.message,
    super.messageKey,
    this.departments = const [],
  });

  factory FetchDepartmentsRootModel.fromJSON(dynamic json) {
    return FetchDepartmentsRootModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      departments: List.generate(json['departments'].length, (i) {
        return DepartmentModel.fromJson(json['departments'][i]);
      }),
    );
  }
}
