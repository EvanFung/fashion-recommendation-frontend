import 'package:flutter/material.dart';
import '../models/quickReplyDialogFlow.dart';

class QuickReply extends StatelessWidget {
  final QuickReplyDialogFlow quickReplyDialogFlow;
  final Function onReply;
  // final Function onReply;
  QuickReply({this.quickReplyDialogFlow, this.onReply});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: quickReplyDialogFlow.replies.map<RaisedButton>((quickReply) {
          return RaisedButton(
            onPressed: () {
              this.onReply(quickReply);
            },
            color: Colors.lightBlueAccent,
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(quickReply, style: TextStyle(fontSize: 12)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
