import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import '../pages/webExplorer.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatCardWidget extends StatelessWidget {
  ChatCardWidget({this.card});

  final CardDialogflow card;

  List<Widget> generateButton(BuildContext context) {
    List<Widget> buttons = [];

    for (var i = 0; i < this.card.buttons.length; i++) {
      buttons.add(new SizedBox(
          width: double.infinity,
          child: new RaisedButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(WebExplorer.routeName);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WebExplorer(
                        title: this.card.title,
                        selectedUrl: "https://${this.card.buttons[i].postback}",
                      )));
              // print(this.card.buttons[i].postback);
            },
            color: Colors.green,
            textColor: Colors.white,
            child: Text(this.card.buttons[i].text),
          )));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: new Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                child: Image.network(
                  this.card.imageUri,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    this.card.title,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    this.card.subtitle,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child:
                          // new Text(this.card.formattedText),
                          Text('You can find similar item in Amazon and eBay')),
                ],
              ),
            ),
            new Container(
              child: new Column(
                children: generateButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _buildCardImage() async {
    if (await canLaunch(this.card.imageUri)) {
      return true;
    } else {
      // return Image.asset("assets/image/belts.jpeg");
      return false;
    }
  }
}
