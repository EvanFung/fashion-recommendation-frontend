import 'package:flutter/material.dart';

class QuickReplyDialogFlow {
  List<dynamic> replies;
  String title;
  QuickReplyDialogFlow(Map response) {
    this.title = response['payload']['quick_replies']['title'];
    this.replies = response['payload']['quick_replies']['quick_replies'];
  }
}
