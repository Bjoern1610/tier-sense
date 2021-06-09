import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sense/model/food/food.dart';
import 'package:food_sense/screen/login/login.dart';

import 'package:swipe_cards/swipe_cards.dart';

import '../colors.dart';
import '../styles.dart';

class Tier extends StatefulWidget {

  Tier({Key key}): super(key: key);

  @override
  _TierState createState() => _TierState();
}

class _TierState extends State<Tier> {

  static const int _MAX_SAMPLES = 2;

  List<SwipeItem> _items;
  MatchEngine _matchEngine;

  StreamSubscription _streamSubscription;
  int _sampleCounter;
  List<int> _xSamples;
  List<int> _ySamples;
  List<int> _zSamples;

  _TierState() {
    _items = [];
    _sampleCounter = 0;
    _xSamples = [];
    _ySamples = [];
    _zSamples = [];
  }

  Future<void> _startListenToSensorEvents() async {
    Login.ESENSE_MANAGER.setSamplingRate(2);
    _streamSubscription = Login.ESENSE_MANAGER.sensorEvents.listen((event) {
      setState(() {
        _sampleCounter++;

        // Current gyro values
        List<int> gyroValues = event.gyro;

        // The earable is located in the ear rotated by 90 degrees clockwise
        int x = gyroValues[0];
        int y = gyroValues[1];
        int z = gyroValues[2];

        print('$x | $y | $z\n----------');

        if (_sampleCounter != _MAX_SAMPLES) {
          _xSamples.add(x);
          _ySamples.add(y);
          _zSamples.add(z);
        } else {
          // Average value to reduce measuring mistakes
          int averagedX = (_xSamples.fold(0, (previous, current) => previous + current) / _xSamples.length).floor();
          int averagedY = (_ySamples.fold(0, (previous, current) => previous + current) / _ySamples.length).floor();
          int averagedZ = (_zSamples.fold(0, (previous, current) => previous + current) / _zSamples.length).floor();

          print('Averaged:\n$averagedX | $averagedY | $averagedZ\n----------');

          _handleGesture(averagedX, averagedY, averagedZ);

          // Reset values
          _sampleCounter = 1;
          _xSamples.clear();
          _ySamples.clear();
          _zSamples.clear();

          _xSamples.add(x);
          _ySamples.add(y);
          _zSamples.add(z);
        }
      });
    });
  }

  Future<void> _pauseListenToSensorEvents() async {
    _streamSubscription.cancel();
  }

  _handleGesture(int x, int y, int z) {
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < FRUITS.length; i++) {
      _items.add(SwipeItem(
        content: Container(
          color: FRUITS[i],
        ),
        nopeAction: () => print('NOPE'),
        superlikeAction: () => print('SUPER'),
        likeAction: () => print('LIKE'),
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _items);

    // We can assume that the eSense connection has successfully been made
    _startListenToSensorEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_MEDIUM_COLOR,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _items[index].content.color,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: BACKGROUND_DARK_COLOR.withOpacity(0.4),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                          spreadRadius: 5
                        ),
                      ]
                    ),
                  );
                },
                onStackFinished: () {
                  print('FINISHED');
                  _pauseListenToSensorEvents();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    onPressed: () {
                      if (_matchEngine.currentItem != null) {
                        _matchEngine.currentItem.nope();
                      }
                    },
                    elevation: 10,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.white,
                    child: Text(
                      "NOPE",
                      style: NOPE_BUTTON_STYLE,
                    )),
                RaisedButton(
                    onPressed: () {
                      if (_matchEngine.currentItem != null) {
                        _matchEngine.currentItem.superLike();
                      }
                    },
                    elevation: 10,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.white,
                    child: Text(
                      "SUPER",
                      style: SUPER_BUTTON_STYLE,
                    )),
                RaisedButton(
                    onPressed: () {
                      if (_matchEngine.currentItem != null) {
                        _matchEngine.currentItem.like();
                      }
                    },
                    elevation: 10,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.white,
                    child: Text(
                      "LIKE",
                      style: LIKE_BUTTON_STYLE,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}