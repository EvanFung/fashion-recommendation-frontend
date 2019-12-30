import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/categories_grid.dart';

class Categories extends StatelessWidget {
  static const routeName = '/categories';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: ListView(
        children: <Widget>[
          CategoriesGrid(),
          CategoriesGrid(),
          CategoriesGrid(),
          CategoriesGrid(),
          CategoriesGrid(),
          CategoriesGrid(),
        ],
      ),
    );
  }
}
