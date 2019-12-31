import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fashion/pages/ChatPage.dart';
// import 'package:fashion/pages/HomePage.dart';
import '../pages/product_screen.dart';
import '../pages/home_page.dart';
// import 'package:fashion/pages/ProductPage.dart';
import 'package:fashion/pages/LooksPage.dart';
import 'package:fashion/pages/ProfilePage.dart';
import '../pages/notification_screen.dart';

class PagesInfo with ChangeNotifier {
  final GlobalKey _drawerKey = GlobalKey();

  final List<Widget> pages = [
    HomePage(),
    LooksPage(),
    // ProductPage(),
    ProductScreen(),
    NotificationScreen(),
    ProfilePage()
  ];
  int selectedPage = 0;

  void changePage(int index) {
    selectedPage = index;
    notifyListeners();
  }

  int get selectedPageIndex {
    return selectedPage;
  }

  GlobalKey get drawerKey {
    return _drawerKey;
  }

  Widget get selectedPageWidget {
    return pages[selectedPage];
  }
}
