import '../widgets/chat_msgItem.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../res/fashionAppTheme.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = ScrollController();

  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CHATBOT'),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildMsgList(),
                //is Sticker ? build sticker widget : empty widget
                buildInput(context),
              ],
            )
          ],
        ));
  }

  Widget buildMsgList() {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: Messages.message.length,
          reverse: true,
          controller: listScrollController,
          itemBuilder: (context, index) {
            print(Messages.message[index].content);
            return ChatMsgItem(
              content: Messages.message[index].content,
            );
          },
        ),
      ),
    );
  }

  Widget buildInput(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Theme.of(context).accentColor,
                onPressed: () {},
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Theme.of(context).accentColor,
                onPressed: () {},
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {},
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: FashionAppTheme.greyColor2, width: 0.8)),
          color: Colors.white),
    );
  }
}
