class Category {
  static const KEY_id = "id";
  static const KEY_title = "title";
  static const KEY_description = "description";
  static const KEY_parentId = "parentId";
  final int id;
  final String title;
  final String description;
  final int parentId;

  Category.fromMap(Map<String, dynamic> map)
      : assert(map != null && map.isNotEmpty),
        id = map[KEY_id],
        parentId = map[KEY_parentId],
        title = map[KEY_title],
        description = map[KEY_description];

  Map<String, dynamic> asMap() =>
      <String, dynamic>{KEY_id: id, KEY_title: title, KEY_description: description, KEY_parentId: parentId};
}
