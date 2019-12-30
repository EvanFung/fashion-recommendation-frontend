import 'package:flutter/material.dart';
import '../models/categories.dart';
import '../widgets/categories_item.dart';

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 12,
        ),
        padding: EdgeInsets.only(left: 28, right: 28, bottom: 10),
        itemCount: categories.length,
        itemBuilder: (BuildContext ctx, index) =>
            CategoriesItem(categories[index]['img'], categories[index]['name']),
      ),
    );
  }
}
