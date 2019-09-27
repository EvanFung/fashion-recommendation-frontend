import 'package:fashion/pages/ProductDetailPage.dart';
import 'package:fashion/pages/ProductPage.dart';
import 'package:fashion/pages/chatPage.dart';
import 'pages/CartPage.dart';
import 'package:fashion/providers/products.dart';
import 'package:fashion/widgets/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/Cart.dart';
import './providers/Orders.dart';
import './providers/PagesInfo.dart';
import 'pages/OrdersPage.dart';
import 'pages/UserProductPage.dart';
import 'pages/EditProductPage.dart';
import 'res/fashionAppTheme.dart';

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
        ),
        ChangeNotifierProvider.value(
          value: PagesInfo(),
        )
      ],
      child: MaterialApp(
        title: 'Fashion Recommendation App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: FashionAppTheme.textTheme,
            fontFamily: 'Lato'),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPageWidget(),
          ProductPage.routeName: (ctx) => ProductPage(),
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrderPage.routeName: (ctx) => OrderPage(),
          UserProductPage.routeName: (ctx) => UserProductPage(),
          EditProductPage.routeName: (ctx) => EditProductPage(),
          ChatPage.routeName: (ctx) => ChatPage()
        },
      ),
    );
  }
}
