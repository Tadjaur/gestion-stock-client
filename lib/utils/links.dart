import 'package:flutter/foundation.dart';

mixin AppAssetsLink {
  static const article_placeholder = "assets/article0";
}

mixin AppLink {
  // PRIVATE
  static const _host = kReleaseMode ? "sinoptique.com" : "192.168.43.156";
  static const _protocol = "http";
  static const _port = kReleaseMode ? 8083 : 8888;
  // PUBLIC
  static const server = "$_protocol://$_host:$_port/gestion_stock";
  static const addArticle = "$server/article/add";
  static const addCategory = "$server/category/add";
  static const addOperation = "$server/operation/add";
  static const addStore = "$server/store/add";
  static String getArticle(id) => "$server/article/get/$id";
  static const getCategory = "$server/category/get";
  static const getStock = "$server/stock/get";
  static const getStore = "$server/store/get";
}
