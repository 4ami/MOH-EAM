import 'package:moh_eam/features/auth/domain/entities/user_entity.dart';

abstract class AdminTableRowData {
  AdminTableRowData({this.selected = false});
  bool selected;
}

final class UserRowData extends AdminTableRowData {
  UserRowData({required this.user, super.selected});

  final UserEntity user;
}
