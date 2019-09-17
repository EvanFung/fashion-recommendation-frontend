import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/App_Drawer.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
      ),
      drawer: AppDrawer(),
    );
  }
}
