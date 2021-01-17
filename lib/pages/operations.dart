import 'dart:convert' as cv;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_manager/model/operation.dart';
import 'package:stock_manager/utils/colors/app_color.dart';
import 'package:stock_manager/utils/links.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/utils/utils.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class OperationsPage extends StatefulWidget {
  static const id = "OperationsPage";

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  List<Widget> _operationsWidget = [];

  @override
  void initState() {
    getBottomOperations().then((value) {
      _operationsWidget = value;
      if (mounted) setState(() {});
    }, onError: (err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          title: "Operations recent",
          color: getAppColors.primary,
          child: Text("Operations recent"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _operationsWidget,
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> getBottomOperations([bool blockRefresh]) async {
    http.Response response;
    if (blockRefresh != true) {
      try {
        response = await http.get(AppLink.getOperation);
      } catch (err) {
        print("$err");
        print(StackTrace.current);
        print(await Utils.userIsConnected);
      }
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final temp = cv.json.decode(response.body) as List;
        if (temp != null) {
          final tempStores = temp.map((e) => Operation.fromMap(e));
          if (tempStores.isNotEmpty) {
            Common.listOperations.clear();
            Common.listOperations.addAll(tempStores);
          }
        }
      }
    }
    final operationsWidget = Common.listOperations
        .map((model) => Card(
              elevation: 10,
              color: getAppColors.primary,
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => OperationsPage(parent: e)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.list,
                        size: 50,
                        color: getAppColors.accent,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Entrepot: ${model.store.title}",
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Article: ${model.article.title}",
                              textAlign: TextAlign.center,
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "le ${model.date.day}/${model.date.month}/${model.date.year} ${model.date.hour}:${model.date.minute}",
                              textAlign: TextAlign.center,
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${model.action.value == 1 ? "Entrée" : "Sortie"}",
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${model.count}",
                              textAlign: TextAlign.center,
                              style: getAppStyles.tsHeader.withValues(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        .toList(growable: true);
    if (operationsWidget.length == 0) {
      operationsWidget.add(
        Card(
          child: Text(
            "Aucune Operation trouvée",
            textAlign: TextAlign.center,
            style: getAppStyles.tsHeader.withValues(color: Colors.white),
          ),
        ),
      );
    }
    return operationsWidget;
  }
}
