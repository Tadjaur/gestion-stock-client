import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stock_manager/model/article.dart';
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/model/operation.dart';
import 'package:stock_manager/model/stock.dart';
import 'package:stock_manager/model/store.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/widgets/toast.dart';

class Common {
  static final listCategories = <Category>[];
  static final listArticles = <Article>[];
  static final listOperations = <Operation>[];
  static final listStock = <Stock>[];
  static Store currentStore;

  static final List<Store> listStores = <Store>[];

  static void openCategoryDialog(BuildContext context, Category category, {void Function(void Function() fn) refresh}) {
    showDialog(
        context: context,
        builder: (currentContext) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Title(
                      child: Text(
                        category.title,
                        style: getAppStyles.tsHeader2,
                      ),
                      color: getAppColors.primary,
                      title: category.title,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      category.description,
                      style: getAppStyles.tsBody1,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    category.parentId == null
                        ? FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(currentContext);
                              openAddCategoryDialog(context, parent: category, refresh: refresh);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Ajouter une sous categorie"))
                        : FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(currentContext);
                              openAddArticleDialog(context, category, refresh: refresh);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Ajouter un article"))
                  ],
                ),
              ),
            ));
  }

  static Future<void> openAddCategoryDialog(BuildContext context,
      {Category parent, void Function(void Function() fn) refresh}) async {
    return showDialog(
        context: context,
        builder: (currentContext) {
          String inputDescription = "", inputTitle = "";
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            title: Title(
              child: Text(
                "Ajouter une ${parent == null ? "" : "sous "}categorie",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "Ajouter une ${parent == null ? "" : "sous "}categorie",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Titre"),
                  style: getAppStyles.tsBody2,
                  onChanged: (txt) => inputTitle = txt,
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  style: getAppStyles.tsBody2,
                  onChanged: (txt) => inputDescription = txt,
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(currentContext);
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text("Annuler"),
                color: getAppColors.primary,
              ),
              FlatButton.icon(
                onPressed: () {
                  listCategories.add(Category.fromMap({
                    Category.KEY_id: Random().nextInt(100000),
                    Category.KEY_parentId: parent?.id,
                    Category.KEY_title: inputTitle,
                    Category.KEY_description: inputDescription,
                  }));
                  Navigator.pop(currentContext);
                  refresh?.call(() {});
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static Future openAddStoreDialog(BuildContext context, {void Function(void Function() fn) refresh}) async {
    return showDialog(
        context: context,
        builder: (currentContext) {
          String inputDescription = "", inputTitle = "";
          final descriptionNode = FocusNode();
          final streamCtrl = StreamController<String>.broadcast();
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            title: Title(
              child: Text(
                "Ajouter un entrepot",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "Ajouter un entrepot",
            ),
            content: Toast(
              message: "",
              decoration: BoxDecoration(color: Colors.red),
              showAsTooltip: true,
              toastStreamHandler: streamCtrl.stream,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Titre"),
                    style: getAppStyles.tsBody2,
                    onSubmitted: (str) => descriptionNode.requestFocus(),
                    onChanged: (txt) => inputTitle = txt.trim(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    focusNode: descriptionNode,
                    decoration: InputDecoration(labelText: "Description"),
                    style: getAppStyles.tsBody2,
                    onChanged: (txt) => inputDescription = txt.trim(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  streamCtrl.close();
                  Navigator.pop(currentContext);
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text("Annuler"),
                color: getAppColors.primary,
              ),
              FlatButton.icon(
                onPressed: () {
                  if (inputTitle.isEmpty || inputDescription.isEmpty) {
                    streamCtrl.add("Veuillez entrer tout les champs");
                    return;
                  }
                  streamCtrl.close();
                  Navigator.pop(currentContext, {
                    Store.KEY_title: inputTitle,
                    Store.KEY_description: inputDescription,
                  });
                  refresh?.call(() {});
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static void openAddArticleDialog(BuildContext context, Category category,
      {void Function(void Function() fn) refresh}) async {
    showDialog(
        context: context,
        builder: (currentContext) {
          String inputDescription = "", inputTitle = "", inputMarque = "";
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            title: Title(
              child: Text(
                "Ajouter un Article",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "Ajouter un Article",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Titre"),
                  style: getAppStyles.tsBody2,
                  onChanged: (txt) => inputTitle = txt,
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  style: getAppStyles.tsBody2,
                  onChanged: (txt) => inputDescription = txt,
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Marque"),
                  style: getAppStyles.tsBody2,
                  onChanged: (txt) => inputMarque = txt,
                ),
              ],
            ),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(currentContext);
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text("Annuler"),
                color: getAppColors.primary,
              ),
              FlatButton.icon(
                onPressed: () {
                  final article = Article.fromMap({
                    Article.KEY_id: Random().nextInt(100000),
                    Article.KEY_categoryId: category.id,
                    Article.KEY_title: inputTitle,
                    Article.KEY_description: inputDescription,
                    Article.KEY_marque: inputMarque,
                  });
                  listArticles.add(article);
                  listStock.add(Stock.fromMap({
                    Stock.KEY_id: Random().nextInt(100000),
                    Stock.KEY_count: 0,
                    Stock.KEY_articleId: article.id,
                    Stock.KEY_storeId: currentStore.id,
                  }));
                  Navigator.pop(currentContext);
                  refresh?.call(() {});
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static void openAddArticleItemDialog(BuildContext context, Article article,
      {void Function(void Function() fn) refresh}) {
    showDialog(
        context: context,
        builder: (currentContext) {
          int inputCount;
          int selectedOperation = 1;
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            title: Title(
              child: Text(
                "Ajouter un Article",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "Ajouter un Article",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("Action"),
                    Expanded(
                      child: StatefulBuilder(builder: (context, refresh) {
                        return DropdownButton(
                            value: selectedOperation,
                            items: [
                              DropdownMenuItem(
                                child: Text("Ajouter"),
                                value: 1,
                                onTap: () => selectedOperation = 1,
                              ),
                              if (getCount(article) > 0)
                                DropdownMenuItem(
                                  child: Text("Suprimer"),
                                  value: -1,
                                  onTap: () => selectedOperation = -1,
                                ),
                            ],
                            onChanged: (value) => refresh(() {}));
                      }),
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Quantite"),
                  style: getAppStyles.tsBody2,
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (txt) => inputCount = int.tryParse(txt.toString()),
                ),
              ],
            ),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(currentContext);
                },
                icon: Icon(Icons.cancel_outlined),
                label: Text("Annuler"),
                color: getAppColors.primary,
              ),
              FlatButton.icon(
                onPressed: () {
                  if (inputCount == null || inputCount == 0)
                    listOperations.add(Operation.fromMap({
                      Operation.KEY_id: Random().nextInt(100000),
                      Operation.KEY_date: DateTime.now(),
                      Operation.KEY_action: selectedOperation,
                      Operation.KEY_count: inputCount,
                      Operation.KEY_storeId: currentStore.id,
                      Operation.KEY_articleId: article.id,
                    }));
                  final stock = listStock
                      .firstWhere((element) => element.storeId == currentStore.id && element.articleId == article.id);
                  if (stock != null) {
                    stock.count += selectedOperation * inputCount;
                  } else {
                    listStock.add(Stock.fromMap({
                      Stock.KEY_id: Random().nextInt(100000),
                      Stock.KEY_count: inputCount,
                      Stock.KEY_articleId: article.id,
                      Stock.KEY_storeId: currentStore.id,
                    }));
                  }
                  Navigator.pop(currentContext);
                  refresh?.call(() {});
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static int getCount(Article article) {
    final items = Common.listStock
        .where((element) => element.articleId == article.id && element.storeId == Common.currentStore.id);
    if (items.length == 0) return 0;
    return items.first.count;
  }
}
