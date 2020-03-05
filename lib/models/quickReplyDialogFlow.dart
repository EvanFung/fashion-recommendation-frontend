import 'package:flutter/material.dart';

class QuickReplyDialogFlow {
  List<dynamic> replies;
  QuickReplyDialogFlow(Map response) {
    this.replies = response['quick_replies']['quick_replies'];
  }
}
