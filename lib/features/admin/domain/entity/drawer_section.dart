import 'package:moh_eam/features/admin/domain/entity/drawer_item.dart';

class DrawerSectionEntity {
  final String sectionKey;
  final List<DrawerItemEntity> items;

  const DrawerSectionEntity({required this.sectionKey, required this.items});
}
