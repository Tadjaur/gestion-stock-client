import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:stock_manager/model/category.dart';
import 'package:stock_manager/widgets/articles.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class Categories extends StatefulWidget {
  final Category category;

  const Categories({Key key, @required this.category})
      : assert(category != null),
        super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final expandCheck = Icon(Icons.arrow_forward_ios);
    final title = InkWell(
      onTap: () {
        isExpanded = !isExpanded;
        setState(() {});
      },
      child: Row(
        children: [
          if (widget.category.parentId != null)
            SizedBox(
              width: 15,
            ),
          !isExpanded
              ? expandCheck
              : Transform.rotate(
                  angle: Math.pi / 2,
                  child: expandCheck,
                ),
          Text("${widget.category.title}"),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            color: Colors.black38,
            height: 3,
          )),
          SizedBox(
            width: 5,
          ),
          IconButton(
              icon: Icon(Icons.more_horiz_rounded),
              onPressed: () => Common.openCategoryDialog(context, widget.category, refresh: setState))
        ],
      ),
    );
    final content = getSubChildren();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (isExpanded) ...content,
      ],
    );
  }

  List<Widget> getSubChildren() {
    if (widget.category.parentId == null)
      return Common.listCategories
          .where((element) => element.parentId == widget.category.id)
          .map((e) => Categories(category: e))
          .toList();
    print(Common.listArticles);
    return Common.listArticles
        .where((element) => element.categoryId == widget.category.id)
        .map((e) => Articles(article: e))
        .toList();
  }
}
