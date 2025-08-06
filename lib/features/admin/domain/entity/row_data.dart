import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

abstract class AdminTableRowData {
  AdminTableRowData({this.selected = false});
  bool selected;
}

final class UserRowData extends AdminTableRowData {
  UserRowData({required this.user, super.selected});

  final UserEntity user;
}
