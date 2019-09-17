import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ProductGrid.dart';
import '../widgets/badge.dart';
import '../providers/Cart.dart';
import './CartPage.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductPage extends StatefulWidget {
  static String routeName = 'Products';
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, child) => Badge(
              child: child,
              value: cartData.totalQuantity.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          )
        ],
      ),
      body: Container(
        child: ProductGrid(_showFavoritesOnly),
      ),
    );
  }
}
