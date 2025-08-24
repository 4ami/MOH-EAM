import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

final class CreateDepartmentModel extends BaseRequest {
  const CreateDepartmentModel({
    required this.nameAR,
    required this.nameEN,
    required this.levelName,
    this.parentId,
    this.extra,
  });

  final String nameAR, nameEN, levelName;
  final String? parentId;
  final Map<String, dynamic>? extra;

  @override
  Map<String, dynamic> toJson() {
    return {
      "name_ar": nameAR,
      "name_en": nameEN,
      "level_name": levelName,
      if (parentId != null) "parent_id": parentId,
      if (extra != null) "extra": extra,
    };
  }

  @override
  String toString() {
    return "New Department (name_ar: $nameAR, name_en: $nameEN, level_name: $levelName, parent_id: $parentId, extra: ${extra.toString()})";
  }
}

class CreateDepartmentResponse extends BaseResponse {
  const CreateDepartmentResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.department,
  });

  final DepartmentModel department;

  factory CreateDepartmentResponse.fromJSON(dynamic json) {
    return CreateDepartmentResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      department: DepartmentModel.fromJson(json['department']),
    );
  }
}
