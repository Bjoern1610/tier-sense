import 'package:FoodSense/screens/login/login.dart';
import 'package:FoodSense/screens/tier/tier.dart';
import 'package:flutter/cupertino.dart';

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