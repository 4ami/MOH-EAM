import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

final class FetchDepartmentChildren extends BaseResponse {
  final List<DepartmentModel> children;
  const FetchDepartmentChildren({
    super.code,
    super.message,
    super.messageKey,
    this.children = const [],
  });

  factory FetchDepartmentChildren.fromJSON(dynamic json) {
    return FetchDepartmentChildren(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['messageKey'] ?? '',
      children: List.generate(
        json['departments'].length,
        (i) => DepartmentModel.fromJson(json['departments'][i]),
      ),
    );
  }
}
