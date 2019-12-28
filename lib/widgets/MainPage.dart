import '../res/fashionAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/PagesInfo.dart';
import '../widgets/CustomBottomNav.dart';
import '../widgets/App_Drawer.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_bottom_nav.dart';

class MainPageWidget extends StatefulWidget {
  MainPageWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageWidgetState();
  }
}

class _MainPageWidgetState extends State<MainPageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FashionAppTheme.lightPrimary,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var pageInfoData = Provider.of<PagesInfo>(context);
    return Scaffold(
      body: pageInfoData.selectedPageWidget,
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
