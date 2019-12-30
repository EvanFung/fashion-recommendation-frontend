import 'package:fashion/pages/ProductDetailPage.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'package:fashion/pages/ProductPage.dart';
import 'package:fashion/pages/chatPage.dart';
import 'pages/splash_screen.dart';
import 'pages/CartPage.dart';
import 'package:fashion/providers/products.dart';
import 'package:fashion/widgets/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/Cart.dart';
import './providers/Orders.dart';
import './providers/PagesInfo.dart';
import './providers/auth.dart';
import './providers/Rating.dart';
import 'pages/OrdersPage.dart';
import 'pages/UserProductPage.dart';
import 'pages/EditProductPage.dart';
import 'res/fashionAppTheme.dart';
import 'pages/auth_screen.dart';
import 'pages/login_page.dart';
import 'pages/categories.dart';

main() {
  initPlatformState();
  runApp(MyApp());
}

void initPlatformState() {
  LeancloudFlutterPlugin leancloudFlutterPlugin =
      LeancloudFlutterPlugin.getInstance();
  String appId = "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz";
  String appKey = "2nDU7yqQoMpsGMTFbWYTdxgG";
  leancloudFlutterPlugin.setLogLevel(LeancloudLoggerLevel.OFF);
  leancloudFlutterPlugin.setRegion(LeancloudCloudRegion.NorthChina);
  leancloudFlutterPlugin.setServer(
      LeancloudOSService.API, "https://wwvo3d7k.lc-cn-n1-shared.com");
  leancloudFlutterPlugin.initialize(appId, appKey);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Orders(),
          ),
          ChangeNotifierProvider.value(
            value: PagesInfo(),
          ),
          ChangeNotifierProxyProvider<Auth, Rating>(
            builder: (ctx, auth, previousRating) =>
                Rating(auth.token, auth.userId),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Fashion Recommendation App',
            home: auth.isAuth
                ? MainPageWidget()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnashot) =>
                        authResultSnashot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : LoginPage(),
                  ),
            theme: FashionAppTheme.lightTheme,
            // initialRoute: '/',
            routes: {
              // '/': (context) => AuthScreen(),
              ProductPage.routeName: (ctx) => ProductPage(),
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrderPage.routeName: (ctx) => OrderPage(),
              UserProductPage.routeName: (ctx) => UserProductPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
              ChatPage.routeName: (ctx) => ChatPage(),
              Categories.routeName: (ctx) => Categories()
            },
          ),
        ));
  }
}
