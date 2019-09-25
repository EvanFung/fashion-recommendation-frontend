import 'package:fashion/res/fashionAppTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/App_Drawer.dart';
import '../res/hexColor.dart';

enum CategoryType { shoes, clothing, pants }

/** Home page */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FashionAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Home'),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getSearchBar(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//search bar
  Widget getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#F8FAFB"),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(13.0),
                      bottomLeft: Radius.circular(13.0),
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    )),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: FashionAppTheme.nearlyBlue),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Search for fashion items',
                              helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: HexColor('#B9BABC')),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 0.2,
                                  color: HexColor("#B9BABC")),
                              border: InputBorder.none),
                          onEditingComplete: () {
                            //todo edirect to search products list page later
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.search,
                        color: HexColor('#B9BABC'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}
