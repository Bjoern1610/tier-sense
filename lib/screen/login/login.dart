import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tier_sense/screen/tier/tier.dart';
import 'package:tier_sense/screen/styles.dart';

import '../colors.dart';

class Login extends StatefulWidget {

  static ESenseManager eSenseManager = ESenseManager();

  Login({Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // The used eSense device name
  static const String _ESENSE_NAME = 'esense-left';
  static const String _CONNECT = 'CONNECT TO ESENSE';
  static const String _CONTINUE = 'PRESS TO CONTINUE';

  /* eSense connection events */
  static const String _UNKNOWN = 'Unknown';
  static const String _CONNECTED = 'Connected';
  static const String _DISCONNECTED = 'Disconnected';
  static const String _DEVICE_FOUND = 'Found';
  static const String _DEVICE_NOT_FOUND = 'Not Found';

  String _buttonStatus;
  String _deviceStatus;
  bool _connected;

  _LoginState() {
    _buttonStatus = _CONNECT;
    _deviceStatus = '';
    _connected = false;
  }

  Future<void> _listenToESense() async {
    Login.eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      setState(() {
        _connected = false;
        switch (event.type) {
          case ConnectionType.unknown:
            _deviceStatus = _UNKNOWN;
            break;
          case ConnectionType.connected:
            _deviceStatus = _CONNECTED;
            _buttonStatus = _CONTINUE;
            _connected = true;
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
    await Login.eSenseManager.connect(_ESENSE_NAME);
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
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: BACKGROUND_MEDIUM_COLOR,
            ),
          ),
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
                  // Headline
                  Text(
                    'TierSense',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelloStockholm',
                      fontSize: 180,
                      shadows: [
                        BoxShadow(
                          color: BACKGROUND_DARK_COLOR,
                          blurRadius: 15,
                        )
                      ],
                    ),
                  ),
                  // Connect button
                  Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_connected) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Tier()));
                        } else {
                          _connectToESense();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.white,
                      ),
                      child: Text(
                        _buttonStatus,
                        style: LOGIN_BUTTON_TEXT_STYLE,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}