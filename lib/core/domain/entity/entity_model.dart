abstract class EntityModel {
  const EntityModel();
  List<String> get columns => [];
  List<String> get props => [];
  Map<String, dynamic> toTableRow();
  String get resourceName;

  static List<String> get tableCols => [];
}
