import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_sense/screen/tier/tier.dart';
import 'package:food_sense/screen/styles.dart';

import '../colors.dart';

class Login extends StatefulWidget {

  static ESenseManager ESENSE_MANAGER = ESenseManager();

  Login({Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static const String _ESENSE_NAME = 'esense-left';
  static const String _CONNECT = 'CONNECT TO ESENSE';
  static const String _CALIBRATE = 'PRESS TO CALIBRATE';

  /* eSense connection events */
  static const String _CONNECTED = 'Connected';
  static const String _DEVICE_NOT_FOUND = 'Not Found';

  String _buttonStatus;
  String _deviceStatus;
  bool _connected;

  _LoginState() {
    _buttonStatus = _CONNECT;
    _deviceStatus = '';
    _connected = false;
  }

  /* eSense methods  */

  Future<void> _listenToESense() async {
    Login.ESENSE_MANAGER.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      setState(() {
        _connected = false;
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = _CONNECTED;
            _connected = true;
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = _DEVICE_NOT_FOUND;
            break;
        }
      });

      Fluttertoast.showToast(
        msg: 'eSense Device: ' + _deviceStatus,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  Future<void> _connectToESense() async {
    await Login.ESENSE_MANAGER.connect(_ESENSE_NAME);
  }

  Widget _buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: BACKGROUND_MEDIUM_COLOR,
      ),
    );
  }

  Widget _buildHeadline() {
    return Stack(
      children: [
        Text(
          'F',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'HelloStockholm',
            fontSize: 200,
            shadows: [
              Shadow(
                color: BACKGROUND_DARK_COLOR,
                blurRadius: 15,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectButton() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (_connected) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Tier()));
          } else {
            _connectToESense();
          }
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        child: Text(
          _buttonStatus,
          style: LOGIN_BUTTON_STYLE,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _listenToESense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundColor(),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  _buildHeadline(),
                  _buildConnectButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}