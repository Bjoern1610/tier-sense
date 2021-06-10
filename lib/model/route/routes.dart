import 'package:flutter/cupertino.dart';
import 'package:food_sense/screen/login/login.dart';
import 'package:food_sense/screen/tier/tier.dart';

class Routes {

  static const String LOGIN = '/login';
  static const String TIER = '/tier';

  static Map<String, WidgetBuilder> get() {
    return {
      LOGIN: (BuildContext context) => Login(),
      TIER: (BuildContext context) => Tier()
    };
  }
}