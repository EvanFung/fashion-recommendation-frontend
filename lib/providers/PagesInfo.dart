import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fashion/pages/ChatPage.dart';
import 'package:fashion/pages/HomePage.dart';
import 'package:fashion/pages/ProductPage.dart';
import 'package:fashion/pages/LooksPage.dart';
import 'package:fashion/pages/ProfilePage.dart';

class PagesInfo with ChangeNotifier {
  final List<Widget> pages = [
    HomePage(),
    LooksPage(),
    ChatPage(),
    ProductPage(),
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

  Widget get selectedPageWidget {
    return pages[selectedPage];
  }
}
