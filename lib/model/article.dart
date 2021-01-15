class Article {
  static const KEY_title = "title";
  static const KEY_description = "description";
  static const KEY_id = "id";
  static const KEY_categoryId = "categoryId";
  static const KEY_marque = "mark";
  static const KEY_img = "image";
  final String title;
  final String description;
  final int id;
  final int categoryId;
  final String marque;

  final String img;

  Article.fromMap(Map<String, dynamic> map)
      : assert(map != null && map.isNotEmpty),
        title = map[KEY_title],
        description = map[KEY_description],
        id = map[KEY_id],
        categoryId = map[KEY_categoryId],
        img = map[KEY_img] ?? "",
        marque = map[KEY_marque];

  Map<String, dynamic> asMap() => <String, dynamic>{
        KEY_title: title,
        KEY_description: description,
        KEY_id: id,
        KEY_img: img,
        KEY_categoryId: categoryId,
        KEY_marque: marque
      };
}
