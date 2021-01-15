import 'package:flutter/foundation.dart';

mixin AppAssetsLink {
  static const article_placeholder = "assets/article0";
}

mixin AppLink {
  static const host = kReleaseMode ? "sinoptique.com" : "192.168.88.139";
  static const protocol = "http";
  static const port = kReleaseMode ? 8083 : 8888;
  static const server = "$protocol://$host:$port/gestion_stock";
  static const getStore = "$server/store/get";
  static const addStore = "$server/store/add";
  static const getArticle = "$server/article/get";
  static const addArticle = "$server/article/add";
  static const getCategory = "$server/category/get";
  static const addCategory = "$server/category/add";
}
