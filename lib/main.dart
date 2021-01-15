import 'package:flutter/material.dart';
import 'package:stock_manager/pages/stores.dart';
import 'package:stock_manager/utils/colors/app_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Stockage',
      theme: ThemeData(
        primaryColor: getAppColors.primary,
        accentColor: getAppColors.accent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StorePage(),
    );
  }
}
