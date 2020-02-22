import 'package:flutter/material.dart';

class TextDialogFlow {
  List<dynamic> text;
  TextDialogFlow(Map response) {
    this.text = response['text']['text'];
  }
}
