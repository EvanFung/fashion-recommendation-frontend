import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/Product.dart';
import '../providers/Rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product-detail';

  Future<RatingItem> _fetchRating(
      BuildContext context, String productId) async {
    final loadedRating =
        await Provider.of<Rating>(context).fetchRatingItem(productId);

    if (loadedRating != null) {
      return loadedRating;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> _fetRatingDetails(
      BuildContext context, String productId) async {
    final Map<String, dynamic> ratingDetails =
        await Provider.of<Rating>(context, listen: false)
            .getProductDifferentRating(productId);
    return ratingDetails;
  }

  @override
  Widget build(BuildContext context) {
    //the id is comefrom
    final product = ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              imageBuilder:
                  (BuildContext context, ImageProvider imgaeProvider) =>
                      Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imgaeProvider,
                  fit: BoxFit.cover,
                )),
              ),
              placeholder: (BuildContext context, String url) => SizedBox(
                child: CircularProgressIndicator(),
                height: 6,
                width: 6,
              ),
              errorWidget: (BuildContext context, String url, error) =>
                  Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              product.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Center(
            child: Container(
              child: FutureBuilder(
                future: _fetchRating(context, product.id),
                builder: (ctx, AsyncSnapshot<RatingItem> snapshot) {
                  Widget returnedWidget;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    returnedWidget = Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data.rating != null) {
                      //if ratingItem is exist
                      returnedWidget = RatingBar(
                        initialRating: snapshot.data.rating,
                        glow: true,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          //not allow user to rate item twice.
                          Provider.of<Rating>(context).reverseRatingBack();
                        },
                      );
                    } else {
                      //rating item not exist
                      returnedWidget = RatingBar(
                        initialRating: 0.0,
                        glow: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          await Provider.of<Rating>(context, listen: false)
                              .addRating(
                                  product.id, product.pId, rating, product);
                        },
                      );
                    }
                  }
                  return returnedWidget;
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ratings & Reviews',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  color: Colors.black38,
                  onPressed: () {
                    print('See All pressed');
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      (product.rating / product.numOfRating).toString(),
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('out of 5'),
                  ],
                ),
              ),
              FutureBuilder(
                future: _fetRatingDetails(context, product.id),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 2.0, top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: List.generate(
                                5,
                                (int index) => Icon(
                                  Icons.star,
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                  4,
                                  (int index) => Icon(
                                        Icons.star,
                                      )),
                            ),
                            Row(
                              children: List.generate(
                                  3,
                                  (int index) => Icon(
                                        Icons.star,
                                      )),
                            ),
                            Row(
                              children: List.generate(
                                  2,
                                  (int index) => Icon(
                                        Icons.star,
                                      )),
                            ),
                            Row(
                              children: List.generate(
                                  1,
                                  (int index) => Icon(
                                        Icons.star,
                                      )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 25.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['five'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['four'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['three'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['two'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data['one'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildComment() {}
}
