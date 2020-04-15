import 'package:fashion/widgets/basicCard.dart';

import '../widgets/ChatMessage.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../res/fashionAppTheme.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import '../models/dialogFlowMessageType.dart';
import '../models/textDialogflow.dart';
import '../widgets/quickReply.dart';
import '../widgets/chatCard.dart';
import '../models/quickReplyDialogFlow.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode focusNode = new FocusNode();
  final List<dynamic> _messages = <dynamic>[];
  List<dynamic> _quickReplies = [];

  int _defaultChoiceIndex = 0;
  bool typing = false;

  @override
  void initState() {
    super.initState();
  }

  void _submitQuery(String query) {
    if (query == null) {
      return;
    }
    _textController.clear();
    setState(() {
      typing = true;
    });
    ChatMessage message = ChatMessage(
      text: query,
      name: 'Evan',
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _dialogFlowResponse(query);
  }

  void _dialogFlowResponse(String query) async {
    _textController.clear();

    try {
      AuthGoogle authGoogle = await AuthGoogle(
              fileJson: 'assets/creds/fashion-rec-sys-ejgagv-9d21e5b1b56d.json')
          .build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);
      query = query.replaceAll('"', '\\"');
      query = query.replaceAll("'", "\\'");
      AIResponse response = await dialogflow.detectIntent(query);
      setState(() {
        typing = false;
      });

      print(response.queryResult.fulfillmentMessages);
      List<dynamic> messages = response.getListMessage();
      messages.forEach((messageMap) {
        dynamic messageWidget = _getWidgetMessage(messageMap);
        if (messageWidget != null) {
          setState(() {
            _messages.insert(0, messageWidget);
          });
        }
      });
    } catch (error) {
      print(error);
    }
  }

  dynamic _getWidgetMessage(message) {
    DialogFlowMessageType tms = DialogFlowMessageType(message);

    if (tms.type == 'simpleResponses') {
      // return SimpleMessage();
    }
    if (tms.type == 'card') {
      return ChatCardWidget(
        card: CardDialogflow(message),
      );
    }

    if (tms.type == 'basicCard') {
      return BasicCardWidget(
        card: BasicCardDialogflow(message),
      );
    }
    if (tms.type == 'text') {
      return ChatMessage(
        name: 'Bot',
        type: false,
        text: TextDialogFlow(message).text[0],
      );
    }

    if (tms.type == 'carouselSelect') {
      return null;
    }
    if (tms.type == 'quickReplies') {
      setState(() {
        _quickReplies = message['quickReplies']['quickReplies'];
      });
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: typing ? Text('Typing...') : Text('CHATBOT'),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildMsgList(),
                buildQuickReplyList(),
                //is Sticker ? build sticker widget : empty widget
                buildInput(context),
              ],
            )
          ],
        ));
  }

  Widget buildQuickReplyList() {
    return _quickReplies.length == 0
        ? Container()
        : Container(
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ChoiceChip(
                    label: Text(_quickReplies[index]),
                    selected: _defaultChoiceIndex == 0,
                    selectedColor: Colors.grey,
                    onSelected: (bool selected) {
                      print(_quickReplies[index]);
                      _submitQuery(_quickReplies[index]);
                      _quickReplies.clear();
                      _defaultChoiceIndex = selected ? 0 : null;
                    },
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                );
              },
              itemCount: _quickReplies.length,
            ),
          );
  }

  Widget buildMsgList() {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: _messages.length,
          reverse: true,
          controller: listScrollController,
          itemBuilder: (context, index) {
            return _messages[index];
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
                  if (_textController.text == "") {
                    print("nothing to submit");
                  } else {
                    _submitQuery(_textController.text);
                  }
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
