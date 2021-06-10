import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sense/model/route/routes.dart';
import 'package:food_sense/screen/login/login.dart';

class FoodSense extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: Routes.get(),
    );
  }
}