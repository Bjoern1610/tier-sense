import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tier_sense/screen/login/login.dart';
import 'package:tier_sense/screen/routes.dart';
import 'package:tier_sense/screen/tier/overview.dart';
import 'package:tier_sense/screen/tier/tier.dart';

/// The stateless TierSense widget.
class TierSense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {LOGIN: (context) => Login(), TIER: (context) => Tier(), OVERVIEW: (context) => Overview()},
      debugShowCheckedModeBanner: false,
    );
  }
}
