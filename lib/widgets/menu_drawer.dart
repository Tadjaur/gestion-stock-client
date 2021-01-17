import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:stock_manager/pages/categories.dart';
import 'package:stock_manager/pages/operations.dart';
import 'package:stock_manager/pages/stores.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/styles/app_style.dart';

class MenuDrawer extends StatelessWidget {
  final BuildContext parentContext;
  final String currentPageId;

  const MenuDrawer({Key key, @required this.parentContext, this.currentPageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dashboard = ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(Icons.store, color: getAppColors.accent),
      title: Text("Stockage", style: getAppStyles.tsBody2.withValues(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        if (currentPageId != StorePage.id)
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  settings: const RouteSettings(name: StorePage.id),
                  pageBuilder: (BuildContext context, animation1, animation2) => StorePage()));
      },
    );
    final operations = ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(Icons.view_list, color: getAppColors.accent),
      title: Text("Operations", style: getAppStyles.tsBody2.withValues(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        if (currentPageId != OperationsPage.id)
          Navigator.push(
              context,
              PageRouteBuilder(
                  settings: const RouteSettings(name: OperationsPage.id),
                  pageBuilder: (BuildContext context, animation1, animation2) => OperationsPage()));
      },
    );
    final categories = ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(
        Icons.category_rounded,
        color: getAppColors.accent,
      ),
      title: Text(
        "Categories",
        style: getAppStyles.tsBody2.withValues(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context);
        if (currentPageId != CategoriesPage.id)
          Navigator.push(
              context,
              PageRouteBuilder(
                  settings: const RouteSettings(name: CategoriesPage.id),
                  pageBuilder: (BuildContext context, animation1, animation2) => CategoriesPage()));
      },
    );
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: DrawerHeader(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              child: Image.asset(
                                "assets/icon.png",
                                fit: BoxFit.cover,
                                // alignment: Alignment.bottomCenter,
                              )),
                          Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.8),
                                      Colors.white.withOpacity(0)
                                    ])),
                              )),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: getAppColors.primary,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  exit(0);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, bottom: 8.0),
                              child: Text(
                                "Gestion de Stock",
                                style:
                                    TextStyle(fontSize: 25, color: getAppColors.primary, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.only(left: 0, bottom: 0, right: 33),
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 69),
                decoration: BoxDecoration(
                    color: getAppColors.primary, border: BorderDirectional(bottom: BorderSide(color: Colors.white10))),
                child: dashboard,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 62),
                decoration: BoxDecoration(
                    color: getAppColors.primary, border: BorderDirectional(bottom: BorderSide(color: Colors.white10))),
                child: operations,
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 20, right: 62),
              //   decoration: BoxDecoration(
              //       color: getAppColors.primary, border: BorderDirectional(bottom: BorderSide(color: Colors.white10))),
              //   child: categories,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
