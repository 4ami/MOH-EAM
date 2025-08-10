import 'package:moh_eam/features/entity/feature/departments/data/model/create_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/delete_department.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_children.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_departments_root_model.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_subtree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/fetch_tree.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/update_department.dart';

abstract interface class DepartmentRepo {
  Future<FetchDepartmentChildren> childrenOf({
    required String token,
    required String parent,
    required String lang,
  });

  Future<FetchDepartmentsRootModel> roots({
    required String token,
    String lang = 'ar',
  });

  Future<FetchSubtree> subtreeOf({
    required String token,
    required String parent,
    String lang = 'ar',
  });

  Future<CreateDepartmentResponse> addNew({
    required String token,
    required CreateDepartmentModel req,
  });

  Future<UpdateDepartmentResponse> update({
    required String token,
    required UpdateDepartmentRequest req,
  });

  Future<DeleteDepartmentResponse> delete({
    required String token,
    required String departmentId,
  });

  Future<FetchTreeResponse> tree({
    required String token,
    required String lang,
    required String id,
  });
}
