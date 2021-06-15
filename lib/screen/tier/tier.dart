import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tier_sense/model/food/food.dart';
import 'package:tier_sense/model/rating.dart';
import 'package:tier_sense/screen/login/login.dart';

import 'package:swipe_cards/swipe_cards.dart';

import '../colors.dart';
import '../styles.dart';
import 'overview.dart';

class Tier extends StatefulWidget {

  static Rating rating = new Rating();

  Tier({Key key}): super(key: key);

  @override
  _TierState createState() => _TierState();
}

class _TierState extends State<Tier> {

  static const int _EARABLE_ROTATION = -90;
  static const int _Y_ERROR_SMOOTHING = 100;
  static const int _Z_ERROR_SMOOTHING = 150;
  static const int _MAX_SAMPLES = 20;
  static const int _SWIPE_THRESHOLD = 600;

  List<SwipeItem> _items;
  MatchEngine _matchEngine;

  StreamSubscription _streamSubscription;
  bool _wait;
  int _sampleCounter;
  int _x;
  int _y;
  int _z;
  List<int> _xSamples;
  List<int> _ySamples;
  List<int> _zSamples;

  _TierState() {
    _items = [];
    _wait = false;
    _sampleCounter = 0;
    _x = 0;
    _y = 0;
    _z = 0;
    _xSamples = [];
    _ySamples = [];
    _zSamples = [];

    Login.eSenseManager.setSamplingRate(_MAX_SAMPLES);
  }

  Future<void> _startListenToSensorEvents() async {
    _streamSubscription = Login.eSenseManager.sensorEvents.listen((event) {
      setState(() {
        _sampleCounter++;

        // Waiting for user to finish swipe gesture
        if (_wait) {
          if (_sampleCounter != 2 * _MAX_SAMPLES) {
            print('WAITING..');
            return;
          } else {
            _sampleCounter = 1;
            _wait = false;
          }
        }

        // Current gyro values with x, y and z
        List<int> gyroValues = event.gyro;

        // Smoothing the y and z values
        gyroValues[1] -= _Y_ERROR_SMOOTHING;
        gyroValues[2] += _Z_ERROR_SMOOTHING;

        // Rotate vector due to approx. 90 counterclockwise rotation while wearing the earable
        gyroValues = _rotateVector(gyroValues, _EARABLE_ROTATION);
        _x = gyroValues[0];
        _y = gyroValues[1];
        _z = gyroValues[2];

        if (_sampleCounter != _MAX_SAMPLES) {
          _xSamples.add(_x);
          _ySamples.add(_y);
          _zSamples.add(_z);
        } else {
          // Take the average value to reduce measuring mistakes
          int averagedX = (_xSamples.fold(0, (previous, current) => previous + current) / _xSamples.length).floor();
          int averagedY = (_ySamples.fold(0, (previous, current) => previous + current) / _ySamples.length).floor();
          int averagedZ = (_zSamples.fold(0, (previous, current) => previous + current) / _zSamples.length).floor();

          print('Averaged:\n$averagedX | $averagedY | $averagedZ\n----------');

          _handleGesture(averagedX, averagedY, averagedZ);

          // Reset values
          _sampleCounter = 0;
          _xSamples.clear();
          _ySamples.clear();
          _zSamples.clear();
        }
      });
    });
  }

  Future<void> _pauseListenToSensorEvents() async {
    _streamSubscription.cancel();
  }

  Future<void> _disconnectFromESense() async {
    Login.eSenseManager.disconnect();
  }

  List<int> _rotateVector(List<int> vector, int degree) {
    List<int> rotatedVector = [0, 0, 0];
    List<List<double>> rotationMatrix = [
      // First row vector
      [cos(degree), -sin(degree), 0.0],
      // Second row vector
      [sin(degree), cos(degree), 0.0],
      // Third row vector
      [0.0, 0.0, 1.0]
    ];

    // Rotate vector defined by rotation matrix
    for(int i = 0; i < rotationMatrix.length; i++) {
      for(int j = 0; j < rotatedVector.length; j++) {
        // Integer values are sufficient thus flooring is okay
        rotatedVector[i] +=  (rotationMatrix[i][j] * vector[j]).floor();
      }
    }

    return rotatedVector;
  }

  _handleGesture(int x, int y, int z) {
    SwipeItem item = _matchEngine.currentItem;
    // Do not swipe when stack is empty
    if (item != null) {
      // Swipe left
      if (y > _SWIPE_THRESHOLD) {
        _wait = true;
        Tier.rating.addNope(item.content.child.data);
        item.nope();
        return;
      }
      // Swipe up
      if (z < -_SWIPE_THRESHOLD) {
        _wait = true;
        Tier.rating.addSuper(item.content.child.data);
        item.superLike();
        return;
      }
      // Swipe right
      if (y < -_SWIPE_THRESHOLD) {
        _wait = true;
        Tier.rating.addLike(item.content.child.data);
        item.like();
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < FRUITS.length; i++) {
      _items.add(SwipeItem(
        content: Container(
          child: Text(
            FRUITS[i],
            softWrap: true,
            textAlign: TextAlign.center,
            style: ITEM_SWIPE_CARD_TEXT_STYLE,
          ),
          color: BACKGROUND_BRIGHT_COLOR,
        ),
        nopeAction: () {
          print('NOPE');
          Tier.rating.addNope(_matchEngine.currentItem.content.child.data);
        },
        superlikeAction: () {
          print('SUPER');
          Tier.rating.addSuper(_matchEngine.currentItem.content.child.data);
        },
        likeAction: () {
          print('LIKE');
          Tier.rating.addLike(_matchEngine.currentItem.content.child.data);
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _items);

    // The eSense connection has successfully been made
    _startListenToSensorEvents();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                      alignment: Alignment.center,
                      child: _items[index].content.child,
                      padding: EdgeInsets.only(left: 10, right: 10),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Overview()));
                    _pauseListenToSensorEvents();
                    _disconnectFromESense();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nope button
                  ElevatedButton(
                      onPressed: () {
                        if (_matchEngine.currentItem != null) {
                          Tier.rating.addNope(_matchEngine.currentItem.content.child.data);
                          _matchEngine.currentItem.nope();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.white,
                      ),
                      child: Text(
                        "NOPE",
                        style: NOPE_BUTTON_TEXT_STYLE,
                      )),
                  // Super button
                  ElevatedButton(
                      onPressed: () {
                        if (_matchEngine.currentItem != null) {
                          Tier.rating.addSuper(_matchEngine.currentItem.content.child.data);
                          _matchEngine.currentItem.superLike();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.white,
                      ),
                      child: Text(
                        "SUPER",
                        style: SUPER_BUTTON_TEXT_STYLE,
                      )),
                  // Like button
                  ElevatedButton(
                      onPressed: () {
                        if (_matchEngine.currentItem != null) {
                          Tier.rating.addLike(_matchEngine.currentItem.content.child.data);
                          _matchEngine.currentItem.like();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: Colors.white,
                      ),
                      child: Text(
                        "LIKE",
                        style: LIKE_BUTTON_TEXT_STYLE,
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}