class Stock {
  static const KEY_id = "id";
  static const KEY_storeId = "storeId";
  static const KEY_articleId = "articleId";
  static const KEY_count = "count";
  final int id;
  final int storeId;
  final int articleId;
  int count;

  Stock.fromMap(Map<String, dynamic> map)
      : assert(map != null && map.isNotEmpty),
        id = map[KEY_id],
        storeId = map[KEY_storeId],
        articleId = map[KEY_articleId],
        count = map[KEY_count];

  Map<String, dynamic> asMap() =>
      <String, dynamic>{KEY_id: id, KEY_storeId: storeId, KEY_articleId: articleId, KEY_count: count};
}
