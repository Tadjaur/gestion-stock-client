import 'package:flutter/material.dart';
import 'package:stock_manager/model/store.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/widgets/categories.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class CategoriesPage extends StatefulWidget {
  final Store store;

  const CategoriesPage({Key key, this.store}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Common.openAddCategoryDialog(context, refresh: setState);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: getCategoriesList(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getCategoriesList() {
    List<Widget> categories =
        Common.listCategories.where((element) => element.parentId == null).map((e) => Categories(category: e)).toList();
    if (categories.length == 0) {
      categories = [
        Text(
          "Aucune categories touvé",
          style: getAppStyles.tsBody2,
        ),
        FlatButton.icon(
          label: Text(
            "Ajouter une categories",
            style: getAppStyles.tsHeader1,
          ),
          icon: Icon(Icons.add),
          onPressed: () {
            Common.openAddCategoryDialog(context, refresh: setState);
          },
        )
      ];
    }
    return categories;
  }
}
