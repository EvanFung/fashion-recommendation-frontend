import 'package:flutter/material.dart';
import '../models/categories.dart';
import '../widgets/categories_item.dart';

class CategoriesGrid extends StatelessWidget {
  final String category;
  CategoriesGrid(this.category);
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
        itemCount: subCategories[category].length,
        itemBuilder: (BuildContext ctx, index) => CategoriesItem(
            subCategories[category][index].img,
            subCategories[category][index].name),
      ),
    );
  }
}
