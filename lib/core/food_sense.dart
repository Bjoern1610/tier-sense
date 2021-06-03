import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sense/routes/routes.dart';
import 'package:food_sense/screens/login/login.dart';

class FoodSense extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: Routes.get(),
    );
  }
}