import 'package:fashion/widgets/home_categoryItem.dart';
import 'package:fashion/widgets/home_popularItem.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class HomePopularListView extends StatefulWidget {
  @override
  _HomePopularListViewState createState() => _HomePopularListViewState();
}

class _HomePopularListViewState extends State<HomePopularListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            return GridView(
              padding: EdgeInsets.all(8),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List.generate(
                Category.popularCourseList.length,
                (index) {
                  var count = Category.popularCourseList.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController.forward();
                  return HomePopularItem(
                    category: Category.popularCourseList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
}
