import 'package:flutter/material.dart';

class LooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              child: TabBar(
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.people),
                    child: Text('Explore'),
                  ),
                  Tab(
                    icon: Icon(Icons.thumb_up),
                    child: Text('Following'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: <Widget>[Page1(), Page2()],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page1'),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page2'),
    );
  }
}
