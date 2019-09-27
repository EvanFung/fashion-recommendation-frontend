import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        child: Center(
          child: Text('CHat page'),
        ),
      ),
    );
  }
}
