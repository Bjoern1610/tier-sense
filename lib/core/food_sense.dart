import 'package:FoodSense/routes/routes.dart';
import 'package:FoodSense/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodSense extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: Routes.get()
    );
  }
}