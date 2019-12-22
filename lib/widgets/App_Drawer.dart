import '../pages/UserProductPage.dart';
import '../pages/OrdersPage.dart';
import '../pages/ProductPage.dart';
import 'package:flutter/material.dart';
import '../providers/PagesInfo.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../pages/chatPage.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat with fashion expert'),
            onTap: () {
              Navigator.of(context).pushNamed(ChatPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              //if you forget to close the modal, it will end with this bug.
              //This _ModalScope<dynamic> widget cannot be marked as needing to build because the framework is locked.
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
