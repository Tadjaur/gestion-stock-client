abstract class Action {
  static const add = _Action(1);
  static const remove = _Action(-1);
}

class _Action implements Action {
  final int value;

  const _Action(this.value);

  @override
  bool operator ==(Object other) => toString() == other.toString();

  @override
  int get hashCode => value;

  @override
  String toString() => value.toString();
}

class Operation {
  static const KEY_id = "id";
  static const KEY_action = "action";
  static const KEY_storeId = "storeId";
  static const KEY_articleId = "articleId";
  static const KEY_count = "count";
  static const KEY_date = "date";
  final int id;
  final Action action;
  final int articleId;
  final int storeId;
  final int count;
  final DateTime date;

  Operation.fromMap(Map<String, dynamic> map)
      : assert(map != null && map.isNotEmpty),
        id = map[KEY_id],
        action = _Action(map[KEY_action] ?? 1),
        count = map[KEY_count],
        articleId = map[KEY_articleId],
        storeId = map[KEY_storeId],
        date = DateTime.tryParse(map[KEY_storeId]);

  Map<String, dynamic> asMap() => <String, dynamic>{
        KEY_id: id,
        KEY_storeId: storeId,
        KEY_articleId: articleId,
        KEY_count: count,
        KEY_action: action,
        KEY_date: date
      };
}
