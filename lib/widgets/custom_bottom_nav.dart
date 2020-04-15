import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/PagesInfo.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var pagesInfo = Provider.of<PagesInfo>(context);
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 7.0,
          ),
          IconButton(
            icon: Icon(
              Icons.home,
              size: 24.0,
            ),
            color: currentIndex == 0
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.caption.color,
            onPressed: () {
              setState(() {
                currentIndex = 0;
              });
              _navigationTap(currentIndex, pagesInfo);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              size: 24.0,
            ),
            color: currentIndex == 1
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.caption.color,
            onPressed: () {
              setState(() {
                currentIndex = 1;
              });
              _navigationTap(currentIndex, pagesInfo);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shop,
              size: 24.0,
            ),
            color: currentIndex == 2
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.caption.color,
            onPressed: () {
              setState(() {
                currentIndex = 2;
              });
              _navigationTap(currentIndex, pagesInfo);
            },
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.notifications,
          //     size: 24.0,
          //   ),
          //   color: currentIndex == 3
          //       ? Theme.of(context).accentColor
          //       : Theme.of(context).textTheme.caption.color,
          //   onPressed: () {
          //     setState(() {
          //       currentIndex = 3;
          //     });
          //     _navigationTap(currentIndex, pagesInfo);
          //   },
          // ),
          IconButton(
            icon: Icon(
              Icons.person,
              size: 24.0,
            ),
            color: currentIndex == 3
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.caption.color,
            onPressed: () {
              setState(() {
                currentIndex = 3;
              });
              _navigationTap(currentIndex, pagesInfo);
            },
          ),
        ],
      ),
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
    );
  }

  void _navigationTap(int index, PagesInfo pagesInfo) {
    final RenderBox box =
        pagesInfo.drawerKey.currentContext?.findRenderObject();
    if (box != null) {
      Navigator.of(context).pop();
    }
    pagesInfo.changePage(currentIndex);
  }
}
