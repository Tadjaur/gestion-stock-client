class Store {
  static const KEY_id = "id";
  static const KEY_title = "title";
  static const KEY_description = "description";
  final int id;
  final String title;
  final String description;

  Store.fromMap(Map map)
      : assert(map != null && map.isNotEmpty),
        id = map[KEY_id],
        title = map[KEY_title],
        description = map[KEY_description];

  Map<String, dynamic> asMap() => <String, dynamic>{
        KEY_id: id,
        KEY_title: title,
        KEY_description: description,
      };
}
