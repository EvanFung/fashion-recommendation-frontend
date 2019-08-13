import 'package:fashion/counter.dart';
import 'package:fashion/widgets/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => Counter(),
        ),
      ],
      child: MaterialApp(
        title: 'Fashion Recommendation App',
        theme: ThemeData(primaryColor: Colors.orange),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPageWidget(),
        },
      ),
    );
  }
}
