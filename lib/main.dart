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
import 'pages/OrdersPage.dart';
import 'pages/UserProductPage.dart';
import 'pages/EditProductPage.dart';
import 'res/fashionAppTheme.dart';
import 'pages/auth_screen.dart';

main() {
  initPlatformState();
  runApp(MyApp());
}

void initPlatformState() {
  LeancloudFlutterPlugin leancloudFlutterPlugin =
      LeancloudFlutterPlugin.getInstance();
  String appId = "5pEU6YStYoYHjxJlibN6ag7d-gzGzoHsz";
  String appKey = "wmGw6rwPS8oquig1csmyzbUl";
  leancloudFlutterPlugin.setLogLevel(LeancloudLoggerLevel.OFF);
  leancloudFlutterPlugin.setRegion(LeancloudCloudRegion.NorthChina);
  leancloudFlutterPlugin.setServer(
      LeancloudOSService.API, "https://5peu6yst.lc-cn-n1-shared.com");
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
                            : AuthScreen(),
                  ),
            theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: FashionAppTheme.textTheme,
                fontFamily: 'Lato'),
            // initialRoute: '/',
            routes: {
              // '/': (context) => AuthScreen(),
              ProductPage.routeName: (ctx) => ProductPage(),
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrderPage.routeName: (ctx) => OrderPage(),
              UserProductPage.routeName: (ctx) => UserProductPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
              ChatPage.routeName: (ctx) => ChatPage()
            },
          ),
        ));
  }
}
