import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/App_Drawer.dart';

/** Home page */
class HomePage extends StatelessWidget {
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
