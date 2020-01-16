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

  @override
  Widget build(BuildContext context) {
    //the id is comefrom
    final product = ModalRoute.of(context).settings.arguments as Product;
    // // ...
    // var loadedProduct;

    // loadedProduct = Provider.of<Products>(
    //   context,
    // ).findById(product.id);

    // //if product is not in our loading product list.
    // //that means the product is coming from search function.
    // if (loadedProduct == null) {

    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: 300,
                width: double.infinity,
                child:

                    // Image.network(
                    //   loadedProduct.imageUrl,
                    //   fit: BoxFit.cover,
                    // ),

                    CachedNetworkImage(
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
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
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
            FutureBuilder(
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
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          // await Provider.of<Rating>(context, listen: false)
                          //     .addRating(productId, snapshot.data.rating,
                          //         snapshot.data.objectId);
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
                }),
          ],
        ),
      ),
    );
  }
}
