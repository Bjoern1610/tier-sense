import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

const LABEL_STYLE = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const HINT_STYLE = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const LOGIN_STYLE = TextStyle(
  color: Color(0xFF425a7a),
  fontFamily: 'OpenSans',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);

final boxDecorationStyle = BoxDecoration(
  color: BACKGROUND_COLOR,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 6,
    ),
  ],
);