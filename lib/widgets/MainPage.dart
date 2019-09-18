import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/PagesInfo.dart';
import '../widgets/CustomBottomNav.dart';
import '../widgets/App_Drawer.dart';

class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageWidgetState();
  }
}

class _MainPageWidgetState extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    var pageInfoData = Provider.of<PagesInfo>(context);
    return Scaffold(
      body: pageInfoData.selectedPageWidget,
      bottomNavigationBar: CustomBottomNav(),
      drawer: AppDrawer(),
    );
  }
}
