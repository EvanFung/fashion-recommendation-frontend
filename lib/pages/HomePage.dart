import 'package:fashion/res/fashionAppTheme.dart';
import 'package:fashion/widgets/home_categoryListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/App_Drawer.dart';
import '../res/hexColor.dart';
import '../widgets/home_popularListView.dart';

enum CategoryType { shoes, clothing, pants, accessories }

/** Home page */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  CategoryType categoryType = CategoryType.clothing;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FashionAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Home'),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.1,
                  child: Column(
                    children: <Widget>[
                      getSearchBar(),
                      getCategory(),
                      Flexible(
                        child: getPopularProduct(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//search bar
  Widget getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#F8FAFB"),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(13.0),
                      bottomLeft: Radius.circular(13.0),
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    )),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: FashionAppTheme.nearlyBlue),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Search for fashion items',
                              helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: HexColor('#B9BABC')),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 0.2,
                                  color: HexColor("#B9BABC")),
                              border: InputBorder.none),
                          onEditingComplete: () {
                            //todo edirect to search products list page later
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.search,
                        color: HexColor('#B9BABC'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  //category ui
  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    var txt = '';
    if (CategoryType.shoes == categoryTypeData) {
      txt = 'Shoes';
    } else if (CategoryType.clothing == categoryTypeData) {
      txt = 'Clothing';
    } else if (CategoryType.pants == categoryTypeData) {
      txt = 'Pants';
    } else if (CategoryType.accessories == categoryTypeData) {
      txt = 'Accessories';
    }
    return Expanded(
      child: Container(
        decoration: new BoxDecoration(
            color: isSelected
                ? FashionAppTheme.nearlyBlue
                : FashionAppTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(color: FashionAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 12, bottom: 12, left: 2, right: 2),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? FashionAppTheme.nearlyWhite
                        : FashionAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                letterSpacing: 0.27,
                color: FashionAppTheme.darkerText),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(
                  CategoryType.clothing, categoryType == CategoryType.clothing),
              SizedBox(
                width: 2,
              ),
              getButtonUI(
                  CategoryType.pants, categoryType == CategoryType.pants),
              SizedBox(
                width: 2,
              ),
              getButtonUI(
                  CategoryType.shoes, categoryType == CategoryType.shoes),
              SizedBox(
                width: 2,
              ),
              getButtonUI(CategoryType.accessories,
                  categoryType == CategoryType.accessories),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        HomeCategoryListView()
      ],
    );
  }

  Widget getPopularProduct() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Popular Fashion Items",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: FashionAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: HomePopularListView(),
          )
        ],
      ),
    );
  }
}
