import 'package:fashion/pages/MenPage.dart';
import 'package:fashion/pages/HomePage.dart';
import 'package:fashion/pages/RecommendPage.dart';
import 'package:fashion/pages/WomenPage.dart';
import 'package:flutter/material.dart';

class TabData {
  final Widget tab;
  final Widget body;
  TabData({this.tab, this.body});
}

final tabDataList = <TabData>[
  TabData(tab: Text('Moment'), body: HomePage()),
  TabData(tab: Text('Recommendations'), body: RecommendPage()),
  TabData(tab: Text('Women'), body: WomenPage()),
  TabData(tab: Text('Men'), body: MenPage()),
];
