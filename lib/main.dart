import 'package:fashion/counter.dart';
import 'package:fashion/pages/ProductDetailPage.dart';
import 'package:fashion/pages/ProductPage.dart';
import 'pages/CartPage.dart';
import 'package:fashion/providers/products.dart';
import 'package:fashion/widgets/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/Cart.dart';
import './providers/Orders.dart';
import 'pages/OrdersPage.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Fashion Recommendation App',
        theme: ThemeData(primaryColor: Colors.black, fontFamily: 'Lato'),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPageWidget(),
          ProductPage.routeName: (ctx) => ProductPage(),
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrderPage.routeName: (ctx) => OrderPage()
        },
      ),
    );
  }
}
