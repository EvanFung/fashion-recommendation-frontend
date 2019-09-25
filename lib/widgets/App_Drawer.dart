import '../pages/UserProductPage.dart';
import '../pages/OrdersPage.dart';
import '../pages/ProductPage.dart';
import 'package:flutter/material.dart';
import '../providers/PagesInfo.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pagesInfo = Provider.of<PagesInfo>(context);
    return Drawer(
      key: pagesInfo.drawerKey,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Product Management'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrderPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
