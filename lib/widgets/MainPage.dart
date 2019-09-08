import 'package:fashion/pages/ChatPage.dart';
import 'package:fashion/pages/HomePage.dart';
import 'package:fashion/pages/ProductPage.dart';
import 'package:fashion/pages/LooksPage.dart';
import 'package:fashion/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageWidgetState();
  }
}

class _MainPageWidgetState extends State<MainPageWidget> {
  final List<Widget> pages = [
    HomePage(),
    LooksPage(),
    ChatPage(),
    ProductPage(),
    ProfilePage()
  ];

  int _selectIndex = 0;
  //Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget getWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    Key key,
//    this.appBar,
//    this.body,
//    this.floatingActionButton,
//    this.floatingActionButtonLocation,
//    this.floatingActionButtonAnimator,
//    this.persistentFooterButtons,
//    this.drawer,
//    this.endDrawer,
//    this.bottomNavigationBar,
//    this.bottomSheet,
//    this.backgroundColor,
//    this.resizeToAvoidBottomPadding = true,
//    this.primary = true,
    return Scaffold(
      body: new Stack(
        children: [
          getWidget(0),
          getWidget(1),
          getWidget(2),
          getWidget(3),
          getWidget(4),
        ],
      ),
//        List<BottomNavigationBarItem>
//        @required this.icon,
//    this.title,
//    Widget activeIcon,
//    this.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: [
//        BottomNavigationBarItem({
          //默认图标样式
//        @required this.icon,
//        this.title,
          //选中的图标样式
//        Widget activeIcon,
          //背景色
//        this.backgroundColor,
//        })
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text('HOME'),
              activeIcon: Icon(
                Icons.home,
              )),
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
          setState(() {
            _selectIndex = index;
          });
        },
        //图标大小
        iconSize: 24,
        //当前选中的索引
        currentIndex: _selectIndex,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        // fixedColor: Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page1'),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page2'),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page3'),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page4'),
    );
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page5'),
    );
  }
}
