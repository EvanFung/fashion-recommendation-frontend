import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/User_ProductItem.dart';
import '../pages/EditProductPage.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user-product';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductPage.routeName);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserProductItem(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl),
                Divider()
              ],
            ),
          ),
        ));
  }
}
