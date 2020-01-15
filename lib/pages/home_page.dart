import 'package:flutter/material.dart';
import '../models/restaurants.dart';
import '../widgets/slide_item.dart';
import '../models/categories.dart';
import '../pages/categories.dart';
import '../widgets/product_search.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/Product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchControl = new TextEditingController();
  final FocusNode _searchNode = FocusNode();
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchProductTitle().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isLoading = true;
      Provider.of<Products>(context).getTrendingProduct().then((_) {
        _isLoading = false;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: ProductSearch(productsData.sourceKeyWords));
                },
                focusNode: _searchNode,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Search..",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  // suffixIcon: Icon(
                  //   Icons.filter_list,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _searchControl,
              ),
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 60.0),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                buildTrendingTitle(context),

                SizedBox(height: 10.0),

                //Horizontal List here
                buildTredingList(context, productsData),

                SizedBox(height: 10.0),

                buildCategoryTitle(context),

                SizedBox(height: 10),
                //Horizontal List here
                buildCategoryList(context),
              ],
            ),
          ),
        ));
  }

  Row buildTrendingTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Trending Fashion Items",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        FlatButton(
          child: Text(
            "See all (10)",
            style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            print('was pressed');
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return Trending();
            //     },
            //   ),
            // );
          },
        ),
      ],
    );
  }

  Container buildCategoryList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      child: ListView.builder(
        primary: false,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: categories == null ? 0 : categories.length,
        itemBuilder: (BuildContext context, int index) {
          Map cat = categories[index];

          return GestureDetector(
            onTap: () {
              print(cat['name']);
              Navigator.of(context)
                  .pushNamed(Categories.routeName, arguments: cat['name']);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      cat["img"],
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.height / 6,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.2, 0.7],
                          colors: [
                            cat['color1'],
                            cat['color2'],
                          ],
                          // stops: [0.0, 0.1],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.height / 6,
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.height / 6,
                        padding: EdgeInsets.all(1),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            cat["name"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row buildCategoryTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Category",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        FlatButton(
          child: Text(
            "See all (9)",
            style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
              color: Theme.of(context).accentColor,
            ),
          ),
          onPressed: () {
            print('see all pressed');
            Navigator.of(context)
                .pushNamed(Categories.routeName, arguments: 'All');
          },
        ),
      ],
    );
  }

  Container buildTredingList(BuildContext context, Products productsData) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.4,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        shrinkWrap: true,
        itemCount: productsData.trendingProducts.length,
        itemBuilder: (BuildContext cotext, int index) {
          Product product = productsData.trendingProducts[index];
          return Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: SlideItem(
              product: product,
              image: product.imageUrl,
              title: product.title,
              address: product.description,
              rating: (product.rating / product.numOfRating).toString() == 'NaN'
                  ? '0'
                  : (product.rating / product.numOfRating).toStringAsFixed(2),
            ),
          );
        },
      ),
    );
  }
}
