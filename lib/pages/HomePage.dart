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
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.people),
                    child: Text('Moment'),
                  ),
                  Tab(
                    icon: Icon(Icons.thumb_up),
                    child: Text('Recommended'),
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
