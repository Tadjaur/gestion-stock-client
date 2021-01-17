import 'package:stock_manager/model/article.dart';
import 'package:stock_manager/model/store.dart';

abstract class Action {
  int value;
  static final add = _Action(1);
  static final remove = _Action(-1);
}

class _Action extends Action {
  final int value;

  _Action(this.value);

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
  static const KEY_storeId = "storeID";
  static const KEY_articleId = "articleID";
  static const KEY_count = "count";
  static const KEY_date = "date";
  final int id;
  final Action action;
  final int articleId;
  final int storeId;
  final int count;
  final DateTime date;
  final Article article;
  final Store store;

  Operation.fromMap(Map<String, dynamic> map)
      : assert(map != null && map.isNotEmpty),
        id = map[KEY_id],
        action = _Action(map[KEY_action] ?? 1),
        count = map[KEY_count],
        articleId = map[KEY_articleId],
        storeId = map[KEY_storeId],
        store = Store.fromMap(map["store"] ?? <String, dynamic>{}),
        article = Article.fromMap(map["article"] ?? <String, dynamic>{}),
        date = DateTime.tryParse(map[KEY_date]);

  Map<String, dynamic> asMap() => <String, dynamic>{
        KEY_id: id,
        KEY_storeId: storeId,
        KEY_articleId: articleId,
        KEY_count: count,
        KEY_action: action,
        KEY_date: date
      };
}
