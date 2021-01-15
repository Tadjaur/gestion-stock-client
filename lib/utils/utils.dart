import 'dart:io';

import 'package:stock_manager/utils/links.dart';

class Utils {
  static Future<bool> get userIsConnected async {
    try {
      final result = await InternetAddress.lookup(AppLink.server /*'google.com'*/); //todo: wait in production mode
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
      throw Error();
    } on SocketException catch (e) {
      print(e);
      print(StackTrace.current);
    }
    return false;
  }
}
