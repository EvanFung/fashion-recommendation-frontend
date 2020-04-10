import 'package:fashion/pages/ProductDetailPage.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
// import 'package:fashion/pages/ProductPage.dart';
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
import './providers/Favorites.dart';
import './providers/Comments.dart';
import './providers/Tweet.dart';
import 'pages/OrdersPage.dart';
import 'pages/UserProductPage.dart';
import 'pages/EditProductPage.dart';
import 'res/fashionAppTheme.dart';
import 'pages/auth_screen.dart';
import 'pages/login_page.dart';
import 'pages/categories.dart';
import 'pages/product_screen.dart';
import 'pages/webExplorer.dart';
import 'pages/newComment.dart';
import 'pages/replyCommentPage.dart';
import 'pages/upload_image_screen.dart';
import 'pages/twitter_profile_page_screen.dart';

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
                auth.userId,
                auth.uId),
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
                Rating(auth.token, auth.userId, auth.uId),
          ),
          ChangeNotifierProxyProvider<Auth, Favorites>(
            builder: (ctx, auth, previousFavorite) =>
                Favorites(auth.token, auth.userId, auth.uId),
          ),
          ChangeNotifierProxyProvider<Auth, Comments>(
            builder: (ctx, auth, previousComment) =>
                Comments(auth.token, auth.userId, auth.uId),
          ),
          ChangeNotifierProxyProvider<Auth, Tweets>(
            builder: (ctx, auth, previousTweets) => Tweets(
                authID: auth.token,
                userID: auth.userId,
                uId: auth.uId,
                username: auth.username),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Fashion Recommendation App',
            home: auth.isAuth
                ? MainPageWidget()
                : FutureBuilder(
                    // future: Future.value(false),
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
              ProductScreen.routeName: (ctx) => ProductScreen(),
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrderPage.routeName: (ctx) => OrderPage(),
              UserProductPage.routeName: (ctx) => UserProductPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
              ChatPage.routeName: (ctx) => ChatPage(),
              Categories.routeName: (ctx) => Categories(),
              WebExplorer.routeName: (ctx) => WebExplorer(),
              NewComment.routeName: (ctx) => NewComment(),
              ReplyCommentPage.routeName: (ctx) => ReplyCommentPage(),
              UploadImageScreen.routeName: (ctx) => UploadImageScreen(),
              TwitterProfilePage.routeName: (ctx) => TwitterProfilePage(),
            },
          ),
        ));
  }
}
