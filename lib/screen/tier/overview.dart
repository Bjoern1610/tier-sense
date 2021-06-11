import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tier_sense/screen/routes.dart';
import 'package:tier_sense/screen/colors.dart';
import 'package:tier_sense/screen/tier/tier.dart';

import '../styles.dart';

class Overview extends StatefulWidget {

  Overview({Key key}): super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  List<ListTile> _superliked;
  List<ListTile> _liked;
  List<ListTile> _disliked;

  _OverviewState() {
    _superliked = [];
    _liked = [];
    _disliked = [];
  }

  ListTile _createListTile(String text) {
    return ListTile(
      title: Text(
        text,
        style: OVERVIEW_ITEM_TEXT_STYLE,
      ),
      tileColor: BACKGROUND_BRIGHT_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Get superliked content
    for(int i = 0; i < Tier.rating.supers.length; i++) {
      ListTile listTile = _createListTile(Tier.rating.supers[i]);
      _superliked.add(listTile);
    }
    // Get liked content
    for(int i = 0; i < Tier.rating.likes.length; i++) {
      ListTile listTile = _createListTile(Tier.rating.likes[i]);
      _liked.add(listTile);
    }
    // Get disliked content
    for(int i = 0; i < Tier.rating.nopes.length; i++) {
      ListTile listTile = _createListTile(Tier.rating.nopes[i]);
      _disliked.add(listTile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: BACKGROUND_MEDIUM_COLOR,
          appBar: AppBar(
            title: Text(
                'Overview',
                style: OVERVIEW_HEADLINE_TEXT_STYLE
            ),
            automaticallyImplyLeading: false,
            elevation: 10,
            centerTitle: true,
            backgroundColor: BACKGROUND_BRIGHT_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: BACKGROUND_MEDIUM_COLOR,
              indicatorWeight: 4,
              tabs: [
                Tab(
                  child: Text(
                    'Superliked',
                    style: OVERVIEW_TAB_TEXT_STYLE,
                  ),
                ),
                Tab(
                  child: Text(
                    'Liked',
                    style: OVERVIEW_TAB_TEXT_STYLE,
                  ),
                ),
                Tab(
                  child: Text(
                    'Disliked',
                    style: OVERVIEW_TAB_TEXT_STYLE,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: _superliked.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shape: _superliked[index].shape,
                    child: _superliked[index],
                  );
                },
              ),
              ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: _liked.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shape: _liked[index].shape,
                    child: _liked[index],
                  );
                },
              ),
              ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: _disliked.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    shape: _disliked[index].shape,
                    child: _disliked[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}