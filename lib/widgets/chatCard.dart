import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import '../pages/webExplorer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/string_utils.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../pages/ProductDetailPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              Provider.of<Products>(context)
                  .getProductById(this.card.buttons[i].postback)
                  .then((product) {
                print(product.title);
                Navigator.of(context)
                    .pushNamed(ProductDetailPage.routeName, arguments: product);
              });
            },
            color: Colors.black38,
            textColor: Colors.white,
            child: Text(this.card.buttons[i].text),
          )));

      buttons.add(
        new SizedBox(
          width: double.infinity,
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => WebExplorer(
                    title: this.card.title,
                    selectedUrl:
                        "https://www.myntra.com/${this.card.title.replaceAll(' ', '-')}",
                  ),
                ),
              );
            },
            color: Colors.black38,
            textColor: Colors.white,
            child: Text("Buy it"),
          ),
        ),
      );
      buttons.add(
        new SizedBox(
          width: double.infinity,
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => WebExplorer(
                    title: this.card.title,
                    selectedUrl:
                        "https://www.amazon.com/s?k=${this.card.title.replaceAll(' ', '-')}",
                  ),
                ),
              );
            },
            color: Colors.black38,
            textColor: Colors.white,
            child: Text("Find Similar"),
          ),
        ),
      );
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
                child:
                    // Image.network(
                    //   this.card.imageUri,
                    //   fit: BoxFit.contain,
                    // ),
                    CachedNetworkImage(
                  imageUrl: "${this.card.imageUri}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
}
