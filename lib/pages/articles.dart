import 'dart:convert' as cv;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/model/store.dart';
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

class _CategoriesPageState extends State<CategoriesPage> {
  List<Widget> _categoriesWidget = [];

  @override
  void initState() {
    getBottomCategories().then((value) {
      _categoriesWidget = value;
      if (mounted) setState(() {});
    }, onError: (err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          title: "${widget.parent == null ? "" : "Sous "}Categories",
          color: getAppColors.primary,
          child: Text("${widget.parent == null ? "" : "Sous "}Categories"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
              ..fields[Store.KEY_title] = res[Store.KEY_title]
              ..fields[Store.KEY_description] = res[Store.KEY_description];
            final response = await mpr.send();
            canRemoveLoader = true;
            if (response.statusCode == 200 || response.statusCode == 201) {
              final data = cv.json.decode(await response.stream.bytesToString()) as Map;
              Common.listStores.add(Store.fromMap(data));
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
          _categoriesWidget = await getBottomCategories(true);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
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

  Future<List<Widget>> getBottomCategories([bool blockRefresh]) async {
    http.Response response;
    if (blockRefresh != true) {
      try {
        response = await http.get(AppLink.getCategory);
      } catch (err) {
        print("$err");
        print(StackTrace.current);
        print(await Utils.userIsConnected);
      }
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final temp = cv.json.decode(response.body) as List;
        if (temp != null) {
          final tempStores = temp.map((e) => Store.fromMap(e));
          if (tempStores.isNotEmpty) {
            Common.listStores.clear();
            Common.listStores.addAll(tempStores);
          }
        }
      }
    }
    final stores = Common.listCategories
        .map((e) => Card(
              elevation: 10,
              color: getAppColors.primary,
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage(parent: e)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.store,
                        size: 50,
                        color: getAppColors.accent,
                      ),
                      SizedBox(height: 5),
                      Text(
                        e.title,
                        style: getAppStyles.tsHeader.withValues(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        e.description,
                        textAlign: TextAlign.center,
                        style: getAppStyles.tsBody.withValues(color: Colors.white),
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
          child: InkWell(
            onTap: () async {
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
                  ..fields[Store.KEY_title] = res[Store.KEY_title]
                  ..fields[Store.KEY_description] = res[Store.KEY_description];
                if (widget.parent != null) {
                  mpr.fields["parentID"] = widget.parent.id.toString();
                }
                final response = await mpr.send();
                canRemoveLoader = true;
                if (response.statusCode == 200 || response.statusCode == 201) {
                  final data = cv.json.decode(await response.stream.bytesToString()) as Map;
                  Common.listStores.add(Store.fromMap(data));
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
              _categoriesWidget = await getBottomCategories(true);
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 50, color: getAppColors.accent),
                  Text(
                    "Ajouter un entrepot",
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
    return stores;
  }
}

// class CategoriesPage extends StatefulWidget {
//   final Store store;
//
//   const CategoriesPage({Key key, this.store}) : super(key: key);
//
//   @override
//   _CategoriesPageState createState() => _CategoriesPageState();
// }
//
// class _CategoriesPageState extends State<CategoriesPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Common.openAddCategoryDialog(context, refresh: setState);
//         },
//         child: Icon(Icons.add),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: getCategoriesList(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Widget> getCategoriesList() {
//     List<Widget> categories =
//     Common.listCategories.where((element) => element.parentId == null).map((e) => Categories(category: e)).toList();
//     if (categories.length == 0) {
//       categories = [
//         Text(
//           "Aucune categories touvé",
//           style: getAppStyles.tsBody2,
//         ),
//         FlatButton.icon(
//           label: Text(
//             "Ajouter une categories",
//             style: getAppStyles.tsHeader1,
//           ),
//           icon: Icon(Icons.add),
//           onPressed: () {
//             Common.openAddCategoryDialog(context, refresh: setState);
//           },
//         )
//       ];
//     }
//     return categories;
//   }
// }