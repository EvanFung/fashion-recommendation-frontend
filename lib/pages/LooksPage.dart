import 'package:flutter/material.dart';
import '../pages/explore_screen.dart';
import '../pages/following_screen.dart';
import '../pages/upload_image_screen.dart';

class LooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(UploadImageScreen.routeName);
        },
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: SafeArea(
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
                      child: Text('MOMENTS'),
                    ),
                    Tab(
                      icon: Icon(Icons.thumb_up),
                      child: Text('FOLLOWING'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: <Widget>[ExploreScreen(), FollowingScreen()],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
