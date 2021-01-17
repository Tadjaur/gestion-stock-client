import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_manager/model/article.dart';
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/model/operation.dart';
import 'package:stock_manager/model/store.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/widgets/toast.dart';

final RouteObserver<PageRoute> defaultRouteObserver = RouteObserver<PageRoute>();

class Common {
  static final listCategories = <Category>[];
  static final listArticles = <Article>[];
  static final listOperations = <Operation>[];
  static final listMapStock = {};
  static Store currentStore;

  static final List<Store> listStores = <Store>[];

  static Future openAddStoreDialog(BuildContext context) async {
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
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static Future openAddCategoriesDialog(BuildContext context, [isSubCategory]) async {
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
                "Ajouter une ${isSubCategory == true ? "Sous " : ""}Categorie",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "Ajouter une ${isSubCategory == true ? "Sous " : ""}Categorie",
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
                    Category.KEY_title: inputTitle,
                    Category.KEY_description: inputDescription,
                  });
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static Future openAddArticleDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (currentContext) {
          String inputDescription = "", inputTitle = "", inputMarque = "";
          final descriptionNode = FocusNode(), markNode = FocusNode();
          final streamCtrl = StreamController<String>.broadcast();
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
                    onSubmitted: (str) => markNode.requestFocus(),
                    decoration: InputDecoration(labelText: "Description"),
                    style: getAppStyles.tsBody2,
                    onChanged: (txt) => inputDescription = txt.trim(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    focusNode: markNode,
                    decoration: InputDecoration(labelText: "Marque"),
                    style: getAppStyles.tsBody2,
                    onChanged: (txt) => inputMarque = txt.trim(),
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
                  if (inputTitle.isEmpty || inputDescription.isEmpty || inputMarque.isEmpty) {
                    streamCtrl.add("Veuillez entrer tout les champs");
                    return;
                  }
                  streamCtrl.close();
                  Navigator.pop(currentContext, {
                    Article.KEY_title: inputTitle,
                    Article.KEY_description: inputDescription,
                    Article.KEY_marque: inputMarque,
                  });
                },
                icon: Icon(Icons.check),
                label: Text("Effectuer"),
                color: getAppColors.secondary,
              )
            ],
          );
        });
  }

  static Future openAddArticleItemDialog(BuildContext context, Article article,
      {void Function(void Function() fn) refresh}) async {
    return showDialog(
        context: context,
        builder: (currentContext) {
          int inputCount;
          DateTime date = DateTime.now();
          final streamCtrl = StreamController<String>.broadcast();
          int selectedOperation = 1;
          return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            title: Title(
              child: Text(
                "+/- ${article.title}",
                style: getAppStyles.tsHeader2,
              ),
              color: getAppColors.primary,
              title: "+/- ${article.title}",
            ),
            content: Toast(
              message: "",
              decoration: BoxDecoration(color: Colors.red),
              showAsTooltip: true,
              toastStreamHandler: streamCtrl.stream,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Action: "),
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
                                if (listMapStock[currentStore.id.toString()] is Map &&
                                    listMapStock[currentStore.id.toString()]["a"] is Map &&
                                    (listMapStock[currentStore.id.toString()]["a"][article.id.toString()] ?? 0) > 0)
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
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Quantite"),
                    style: getAppStyles.tsBody2,
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (txt) => inputCount = int.tryParse(txt.toString()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(builder: (context, reload) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FlatButton.icon(
                        onPressed: () async {
                          date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                                  lastDate: DateTime.now().add(Duration(days: 365))) ??
                              date;
                          reload(() {});
                        },
                        icon: Icon(
                          Icons.date_range,
                          color: getAppColors.accent,
                        ),
                        label: Text(
                          "Date: ${date.day}/${date.month}/${date.year}",
                          style: getAppStyles.tsBody1.withValues(color: Colors.white),
                        ),
                        color: getAppColors.primary,
                      ),
                    );
                  }),
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
                  if (inputCount == null) {
                    streamCtrl.add("Veuillez entrer un nombre valide");
                    return;
                  }
                  streamCtrl.close();
                  Navigator.pop(currentContext, {
                    "input": inputCount.toString(),
                    "op": selectedOperation.toString(),
                    "date": date.toIso8601String()
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
}
