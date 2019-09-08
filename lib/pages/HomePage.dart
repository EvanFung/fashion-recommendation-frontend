import 'package:fashion/pages/MomentPage.dart';
import 'package:fashion/pages/RecommendPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fashion/res/TabData.dart' as TabDataList;
import 'package:flutter/material.dart';

/** Home page */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final tabBarList = TabDataList.tabDataList.map((item) => item.tab).toList();
  final tabBarViewList =
      TabDataList.tabDataList.map((item) => item.body).toList();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.people,
                      color: Colors.grey,
                    ),
                    child:
                        Text('Moment', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Recommended',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: <Widget>[MomentPage(), RecommendPage()],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
