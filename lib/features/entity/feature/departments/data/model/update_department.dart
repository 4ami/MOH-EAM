import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

class UpdateDepartmentRequest extends BaseRequest {
  final String id;
  final String? nameAR, nameEN, levelName, parentId;
  final bool? rootLevel;
  final Map<String, dynamic>? extra;

  const UpdateDepartmentRequest({
    required this.id,
    this.nameAR,
    this.nameEN,
    this.levelName,
    this.parentId,
    this.rootLevel,
    this.extra,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "department_id": id,
      if (nameAR != null) "name_ar": nameAR,
      if (nameEN != null) "name_en": nameEN,
      if (rootLevel != null) "root_level": rootLevel,
      if (levelName != null) "level_name": levelName,
      if (parentId != null) "parent_id": parentId,
      if (extra != null) "extra": extra,
    };
  }

  @override
  String toString() {
    return "UpdateDepartmentRequest(id: $id, name_ar:$nameAR, name_en:$nameEN, root_level: $rootLevel, level_name:$levelName, parent_id:$parentId)";
  }
}

final class UpdateDepartmentResponse extends BaseResponse {
  const UpdateDepartmentResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.department,
  });

  final DepartmentModel department;

  factory UpdateDepartmentResponse.fromJSON(dynamic json) {
    return UpdateDepartmentResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      department: DepartmentModel.fromJson(json['department']),
    );
  }
}
