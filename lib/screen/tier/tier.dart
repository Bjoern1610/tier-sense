import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:swipe_cards/swipe_cards.dart';

class Tier extends StatefulWidget {

  Tier({Key key}): super(key: key);

  @override
  _TierState createState() => _TierState();
}

class _TierState extends State<Tier> {

  MatchEngine _matchEngine;
  List<SwipeItem> _items;
  List<Color> _colors;

  _TierState() {
    _items = [];
    _colors = [Colors.red, Colors.green, Colors.blue];
  }

  @override
  void initState() {
    for(int i = 0; i < _colors.length; i++) {
      _items.add(SwipeItem(
        content: Container(
          color: _colors[i],
        ),
        nopeAction: () => print('NOPE'),
        superlikeAction: () => print('SUPERLIKE'),
        likeAction: () => print('LIKE')
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _items);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (context, index) {
                  return Container(
                    color: _items[index].content.color,
                  );
                },
                onStackFinished: () => print('FINISHED'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    onPressed: () {
                      _matchEngine.currentItem.nope();
                    },
                    child: Text("Nope")),
                RaisedButton(
                    onPressed: () {
                      _matchEngine.currentItem.superLike();
                    },
                    child: Text("Superlike")),
                RaisedButton(
                    onPressed: () {
                      _matchEngine.currentItem.like();
                    },
                    child: Text("Like"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}