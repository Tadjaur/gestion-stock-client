import 'package:flutter/material.dart';
import 'package:stock_manager/model/article.dart';
import 'package:stock_manager/utils/styles/app_style.dart';
import 'package:stock_manager/widgets/widgets_util.dart';

class Articles extends StatefulWidget {
  final Article article;

  const Articles({Key key, this.article}) : super(key: key);

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Icon(Icons.article),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title,
                style: getAppStyles.tsHeader.withValues(color: Colors.black),
              ),
              Text(
                widget.article.description,
                style: getAppStyles.tsBody1,
              ),
            ],
          ),
        ),
        Text("Count: ${Common.getCount(widget.article)}"),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () {
            Common.openAddArticleItemDialog(context, widget.article, refresh: setState);
          },
        ),
      ],
    );
  }
}
