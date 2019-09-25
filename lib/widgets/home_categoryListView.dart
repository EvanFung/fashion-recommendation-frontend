import '../widgets/home_categoryItem.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class HomeCategoryListView extends StatefulWidget {
  @override
  _HomeCategoryListViewState createState() => _HomeCategoryListViewState();
}

class _HomeCategoryListViewState extends State<HomeCategoryListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(microseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(microseconds: 1000));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 16),
      child: Container(
        height: 135,
        width: double.infinity,
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                //return a loading image instead later??
                return SizedBox();
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 16, left: 16),
                  itemCount: Category.categoryList.length,
                  itemBuilder: (ctx, index) {
                    var count = Category.categoryList.length > 10
                        ? 10
                        : Category.categoryList.length;
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    return HomeCategoryItem(
                      category: Category.categoryList[index],
                      animation: animation,
                      animationController: animationController,
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
