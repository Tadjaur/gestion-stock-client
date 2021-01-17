import 'dart:convert' as cv;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/pages/articles.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/links.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/utils/utils.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class CategoriesPage extends StatefulWidget {
  static const id = "CategoriesPage";
  final Category parent;

  const CategoriesPage({Key key, this.parent}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with RouteAware {
  List<Widget> _categoriesWidget = [];

  @override
  void initState() {
    getCategories().then((value) {
      _categoriesWidget = value;
      if (mounted) setState(() {});
    }, onError: (err) => print(err));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    defaultRouteObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    defaultRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    getCategories(true).then((value) {
      _categoriesWidget = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          title: widget.parent?.title ?? "Categories",
          color: getAppColors.primary,
          child: Text(widget.parent?.title ?? "Categories"),
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () => addCategory(context),
          child: Icon(Icons.add),
        );
      }),
      body: SafeArea(
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            children: _categoriesWidget,
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> getCategories([bool blockRefresh]) async {
    http.Response response;
    if (blockRefresh != true) {
      try {
        final extra = widget.parent == null ? "" : "?parentID=${widget.parent.id}";
        response = await http.get(AppLink.getCategory + extra);
      } catch (err) {
        print("$err");
        print(StackTrace.current);
        print(await Utils.userIsConnected);
      }
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final temp = cv.json.decode(response.body) as List;
        if (temp != null) {
          final tempCategories = temp.map((e) {
            print(e);
            return Category.fromMap(e);
          });
          if (tempCategories.isNotEmpty) {
            Common.listCategories.addAll(tempCategories);
            final Set exist = <int>{};
            Common.listCategories.removeWhere((element) {
              if (exist.contains(element.id)) return true;
              exist.add(element.id);
              return false;
            });
          }
        }
      }
    }
    final stores = Common.listCategories
        .where((element) => widget.parent == null ? element.parentId == null : element.parentId == widget.parent.id)
        .map((e) => Card(
              elevation: 10,
              color: getAppColors.primary,
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (widget.parent == null) return CategoriesPage(parent: e);
                        e.parent = widget.parent;
                        return ArticlesPage(parent: e);
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 50,
                        color: getAppColors.accent,
                      ),
                      SizedBox(height: 5),
                      Text(
                        e.title,
                        style: getAppStyles.tsHeader.withValues(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        e.description,
                        textAlign: TextAlign.center,
                        style: getAppStyles.tsBody.withValues(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        (_getStockCategory(e) ?? 0).toString(),
                        textAlign: TextAlign.center,
                        style: getAppStyles.tsHeader.withValues(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
    if (stores.length == 0) {
      stores.add(
        Card(
          elevation: 10,
          color: getAppColors.secondary,
          child: Builder(builder: (context) {
            return InkWell(
              onTap: () => addCategory(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 50, color: getAppColors.accent),
                    Text(
                      "Ajouter une ${widget.parent == null ? "" : "sous "}categorie",
                      textAlign: TextAlign.center,
                      style: getAppStyles.tsHeader.withValues(color: Colors.white),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }
    return stores;
  }

  Future addCategory(BuildContext context) async {
    final res = await Common.openAddCategoriesDialog(context, widget.parent != null);
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
      final mpr = http.MultipartRequest("POST", Uri.parse(AppLink.addCategory))
        ..fields[Category.KEY_title] = res[Category.KEY_title]
        ..fields[Category.KEY_description] = res[Category.KEY_description];
      if (widget.parent != null) {
        mpr.fields["parentID"] = widget.parent.id.toString();
      }
      final response = await mpr.send();
      canRemoveLoader = true;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = cv.json.decode(await response.stream.bytesToString()) as Map;
        Common.listCategories.add(Category.fromMap(data));
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
    _categoriesWidget = await getCategories(true);
    setState(() {});
  }

  int _getStockCategory(Category e) {
    if (Common.listMapStock[Common.currentStore.id.toString()] == null) return null;
    if (Common.listMapStock[Common.currentStore.id.toString()][widget.parent == null ? "c1" : "c2"] == null)
      return null;
    return Common.listMapStock[Common.currentStore.id.toString()][widget.parent == null ? "c1" : "c2"][e.id.toString()];
  }
}
