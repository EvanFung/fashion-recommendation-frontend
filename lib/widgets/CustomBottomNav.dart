import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/PagesInfo.dart';

class CustomBottomNav extends StatelessWidget {
  Widget build(BuildContext context) {
    var pagesInfo = Provider.of<PagesInfo>(context);
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text('HOME'),
          activeIcon: Icon(
            Icons.home,
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye,
            ),
            title: Text('LOOKS'),
            activeIcon: Icon(
              Icons.remove_red_eye,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
            ),
            title: Text('CHATS'),
            activeIcon: Icon(
              Icons.group,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.shop,
            ),
            title: Text('PRODUCTS'),
            activeIcon: Icon(
              Icons.shop,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text('ME'),
            activeIcon: Icon(
              Icons.person,
            )),
      ],
      onTap: (int index) {
        pagesInfo.changePage(index);
      },
      iconSize: 24,
      currentIndex: pagesInfo.selectedPageIndex,
      type: BottomNavigationBarType.fixed,
    );
  }
}
