import '../widgets/chat_msgItem.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../res/fashionAppTheme.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _submitQuery(String query) {
    _textController.clear();
    _dialogFlowResponse(query);
  }

  void _dialogFlowResponse(String query) async {
    _textController.clear();
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: 'assets/creds/fashion-rec-sys-ejgagv-9d21e5b1b56d.json')
        .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    print(response.getMessage());
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
          Flexible(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: '    Type your message...',
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
                onPressed: () {
                  _submitQuery(_textController.text);
                },
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
