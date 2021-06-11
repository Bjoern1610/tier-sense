import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sense/screen/routes.dart';
import 'package:food_sense/screen/login/login.dart';
import 'package:food_sense/screen/tier/overview.dart';
import 'package:food_sense/screen/tier/tier.dart';

class FoodSense extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {
        LOGIN: (context) => Login(),
        TIER: (context) => Tier(),
        OVERVIEW: (context) => Overview()
      },
    );
  }
}