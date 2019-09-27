import 'package:flutter/material.dart';

class ChatMsgItem extends StatelessWidget {
  final String idFrom;
  final String content;
  final String idTo;
  final DateTime timestamp;
  final int type;

  ChatMsgItem(
      {this.idFrom, this.content, this.idTo, this.timestamp, this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            content,
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(bottom: 20.0, right: 10.0),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
