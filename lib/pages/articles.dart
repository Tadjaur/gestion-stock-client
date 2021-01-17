import 'dart:convert' as cv;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_manager/model/article.dart';
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/model/operation.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/links.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/utils/utils.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class ArticlesPage extends StatefulWidget {
  static const id = "ArticlesPage";
  final Category parent;

  const ArticlesPage({Key key, @required this.parent})
      : assert(parent != null, "parent category must not been null"),
        super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Widget> _articlesWidget = [];

  @override
  void initState() {
    getBottomArticles().then((value) {
      _articlesWidget = value;
      if (mounted) setState(() {});
    }, onError: (err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          title: "${widget.parent.title} > Articles",
          color: getAppColors.primary,
          child: Text("${widget.parent.parent?.title} - ${widget.parent.title}"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addArticle,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _articlesWidget,
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> getBottomArticles([bool blockRefresh]) async {
    http.Response response;
    if (blockRefresh != true) {
      try {
        response = await http.get(AppLink.getArticle(widget.parent.id));
      } catch (err) {
        print("$err");
        print(StackTrace.current);
        print(await Utils.userIsConnected);
      }
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final temp = cv.json.decode(response.body) as List;
        if (temp != null) {
          final tempStores = temp.map((e) => Article.fromMap(e));
          if (tempStores.isNotEmpty) {
            Common.listArticles.addAll(tempStores);
            final Set exist = <int>{};
            Common.listArticles.removeWhere((element) {
              if (exist.contains(element.id)) return true;
              exist.add(element.id);
              return false;
            });
          }
        }
      }
    }
    final articlesWidget = Common.listArticles
        .where((element) => element.categoryId == widget.parent.id)
        .map((model) => Card(
              elevation: 10,
              color: getAppColors.primary,
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlesPage(parent: e)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.store,
                        size: 50,
                        color: getAppColors.accent,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              model.title,
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              model.description,
                              textAlign: TextAlign.center,
                              style: getAppStyles.tsBody.withValues(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Quantite: ",
                        style: getAppStyles.tsBody1.withValues(color: Colors.white),
                      ),
                      Text(
                        (getArticleStock(model) ?? 0).toString(),
                        textAlign: TextAlign.center,
                        style: getAppStyles.tsHeader.withValues(color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Builder(builder: (context) {
                        return IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: getAppColors.accent,
                          ),
                          onPressed: () async {
                            final res = await Common.openAddArticleItemDialog(context, model);
                            if (res is Map) {
                              bool canRemoveLoader = false;
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    Future.doWhile(() async {
                                      await Future.delayed(Duration(milliseconds: 50));
                                      if (canRemoveLoader) Navigator.pop(context);
                                      return !canRemoveLoader;
                                    });
                                    return AlertDialog(
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          CircularProgressIndicator(
                                            backgroundColor: getAppColors.primary,
                                          ),
                                          Text("loading...")
                                        ],
                                      ),
                                    );
                                  });
                              final mpr = http.MultipartRequest("POST", Uri.parse(AppLink.addOperation))
                                ..fields.addAll({
                                  Operation.KEY_storeId: Common.currentStore.id.toString(),
                                  Operation.KEY_articleId: model.id.toString(),
                                  Operation.KEY_count: res["input"] ?? (throw Error()),
                                  Operation.KEY_action: res["op"] ?? (throw Error()),
                                  Operation.KEY_date: res["date"] ?? (throw Error()),
                                });
                              final response = await mpr.send();
                              canRemoveLoader = true;
                              if (response.statusCode == 200 || response.statusCode == 201) {
                                final data = cv.json.decode(await response.stream.bytesToString()) as Map;
                                final op = Operation.fromMap(data);
                                Common.listOperations.add(op);
                                addArticleStock(model, op.count * op.action.value);
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "Erreur! veuillez reessayer",
                                    style: getAppStyles.tsHeader.withValues(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              }
                              _articlesWidget = await getBottomArticles(true);
                              setState(() {});
                            }
                          },
                        );
                      })
                    ],
                  ),
                ),
              ),
            ))
        .toList();
    if (articlesWidget.length == 0) {
      articlesWidget.add(
        Card(
          elevation: 10,
          color: getAppColors.secondary,
          child: InkWell(
            onTap: addArticle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 50, color: getAppColors.accent),
                  Text(
                    "Ajouter un article",
                    textAlign: TextAlign.center,
                    style: getAppStyles.tsHeader.withValues(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return articlesWidget;
  }

  Future addArticle() async {
    final res = await Common.openAddArticleDialog(context);
    if (res is Map) {
      bool canRemoveLoader = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            Future.doWhile(() async {
              await Future.delayed(Duration(milliseconds: 50));
              if (canRemoveLoader) Navigator.pop(context);
              return !canRemoveLoader;
            });
            return AlertDialog(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: getAppColors.primary,
                  ),
                  Text("loading...")
                ],
              ),
            );
          });
      final mpr = http.MultipartRequest("POST", Uri.parse(AppLink.addArticle))
        ..fields[Article.KEY_title] = res[Article.KEY_title]
        ..fields[Article.KEY_marque] = res[Article.KEY_marque]
        ..fields[Article.KEY_categoryId] = widget.parent.id.toString()
        ..fields[Article.KEY_description] = res[Article.KEY_description];
      final response = await mpr.send();
      canRemoveLoader = true;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = cv.json.decode(await response.stream.bytesToString()) as Map;
        Common.listArticles.add(Article.fromMap(data));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Erreur! veuillez reessayer",
            style: getAppStyles.tsHeader.withValues(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
    _articlesWidget = await getBottomArticles(true);
    setState(() {});
  }

  int getArticleStock(Article model) {
    if (Common.listMapStock[Common.currentStore.id.toString()] == null) return null;
    if (Common.listMapStock[Common.currentStore.id.toString()]["a"] == null) return null;
    return Common.listMapStock[Common.currentStore.id.toString()]["a"][model.id.toString()];
  }

  addArticleStock(Article model, int count) {
    if (Common.listMapStock[Common.currentStore.id.toString()] == null) {
      Common.listMapStock[Common.currentStore.id.toString()] = {"count": 0, "c1": {}, "c2": {}, "a": {}};
    }
    Common.listMapStock[Common.currentStore.id.toString()]["count"] += count;
    Common.listMapStock[Common.currentStore.id.toString()]["a"][model.id.toString()] ??= 0;
    Common.listMapStock[Common.currentStore.id.toString()]["c2"][widget.parent.id.toString()] ??= 0;
    Common.listMapStock[Common.currentStore.id.toString()]["c1"][widget.parent.parent.id.toString()] ??= 0;
    Common.listMapStock[Common.currentStore.id.toString()]["a"][model.id.toString()] += count;
    Common.listMapStock[Common.currentStore.id.toString()]["c2"][widget.parent.id.toString()] += count;
    Common.listMapStock[Common.currentStore.id.toString()]["c1"][widget.parent.parent.id.toString()] += count;
  }
}
