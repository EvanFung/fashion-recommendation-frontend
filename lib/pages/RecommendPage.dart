import 'package:flutter/material.dart';

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  int count = 0;

  void add() {
    setState(() {
      count++;
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          Center(
            child: Text('Recommend page $count'),
          ),
          FlatButton(
            onPressed: add,
            child: Icon(Icons.add),
          )
        ],
      ),
    ));
  }
}
