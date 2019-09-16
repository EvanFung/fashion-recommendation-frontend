import 'package:fashion/counter.dart';
import 'package:fashion/pages/ProductDetailPage.dart';
import 'pages/CartPage.dart';
import 'package:fashion/providers/products.dart';
import 'package:fashion/widgets/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/Cart.dart';

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
        )
      ],
      child: MaterialApp(
        title: 'Fashion Recommendation App',
        theme: ThemeData(primaryColor: Colors.black, fontFamily: 'Lato'),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPageWidget(),
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
        },
      ),
    );
  }
}
