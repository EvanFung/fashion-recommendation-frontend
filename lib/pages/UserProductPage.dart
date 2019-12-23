import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/User_ProductItem.dart';
import '../pages/EditProductPage.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user-product';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    //inifinity loop to fetching data.
    // final productsData = Provider.of<Products>(context);
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
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) => Column(
                                children: <Widget>[
                                  UserProductItem(
                                      productsData.items[i].id,
                                      productsData.items[i].title,
                                      productsData.items[i].imageUrl,
                                      productsData.items[i].creatBy),
                                  Divider()
                                ],
                              ),
                            ),
                          ),
                        ))));
  }
}
