import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sense/screen/tier/tier.dart';
import 'package:food_sense/style/style.dart';

class Login extends StatefulWidget {

  Login({Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  static const Color _BACKGROUND_COLOR = Color(0xFF425a7a);
  static const String _ESENSE_NAME = 'esense-left';
  static const String _CONNECT = 'CONNECT TO ESENSE';
  static const String _CONTINUE = 'PRESS TO CONTINUE';
  static const String _CONNECTING = 'CONNECTING..';
  static const String _CONNECTION_FAILED = 'CONNECTION FAILED';

  /* eSense connection events */
  static const String _CONNECTED = 'CONNECTED';
  static const String _DISCONNECTED = 'DISCONNECTED';
  static const String _DEVICE_FOUND = 'DEVICE FOUND';
  static const String _DEVICE_NOT_FOUND = 'DEVICE NOT FOUND';
  static const String _UNKNOWN = 'UNKNOWN';

  String _buttonStatus;
  String _deviceStatus;
  bool _connected;

  _LoginState() {
    _buttonStatus = _CONNECT;
  }

  Widget _buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: _BACKGROUND_COLOR,
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
                color: Colors.black,
                blurRadius: 20,
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
          style: BUTTON_STYLE,
        ),
      ),
    );
  }

  /* eSense methods  */

  Future<void> _listenToESense() async {
    ESenseManager().connectionEvents.listen((event) {
      setState(() {
        _connected = false;
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = _CONNECTED;
            _connected = true;
            _buttonStatus = _CONTINUE;
            break;
          case ConnectionType.disconnected:
            _deviceStatus = _DISCONNECTED;
            break;
          case ConnectionType.device_found:
            _deviceStatus = _DEVICE_FOUND;
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = _DEVICE_NOT_FOUND;
            break;
          case ConnectionType.unknown:
            _deviceStatus = _UNKNOWN;
            break;
        }
      });
      print('CONNECTION event: $event');
    });
  }

  Future<void> _connectToESense() async {
    _connected = await ESenseManager().connect(_ESENSE_NAME);
    setState(() => _deviceStatus = _connected ? _CONNECTING : _CONNECTION_FAILED);
    print('Connecting.. connected: $_connected');
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