import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Product.dart';
import '../providers/Rating.dart';
import '../providers/Comments.dart';
import '../providers/Comment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../pages/newComment.dart';
import '../pages/replyCommentPage.dart';

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

  Future<List<Comment>> _fetchComments(
      BuildContext context, String productId) async {
    return await Provider.of<Comments>(context, listen: false)
        .fetchCommentByProductId(productId);
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              (product.rating / product.numOfRating).toString(),
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
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
                  } else if (snapshot.hasError) {
                    return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                  } else if (snapshot.connectionState == ConnectionState.done) {
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
          FutureBuilder(
            future: _fetRatingDetails(context, product.id),
            builder: (BuildContext ctx,
                AsyncSnapshot<Map<String, dynamic>> snashot) {
              if (snashot.connectionState == ConnectionState.done) {
                if (snashot.hasError) {
                  return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                } else {
                  return _buildChatBar(ctx, snashot, product);
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Reviews',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  tooltip: 'Leave a comment',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      NewComment.routeName,
                      arguments: {
                        'product': product,
                        'comment': null,
                      },
                    );
                  },
                )
              ],
            ),
          ),
          FutureBuilder(
            future: _fetchComments(context, product.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                } else {
                  List<Comment> comments = snapshot.data;
                  List<Widget> reviews = comments
                      .map((comment) => _buildReview(context, comment, product))
                      .toList();
                  return Column(
                    children: reviews,
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatBar(BuildContext context,
      AsyncSnapshot<Map<String, dynamic>> snashot, Product product) {
    /// Rating chart lines
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// 5 stars and progress bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 24.0)),
                Expanded(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.green),
                    child: LinearProgressIndicator(
                      value: snashot.data['five'] != 0
                          ? (snashot.data['five'] / product.numOfRating)
                          : 0,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 24.0)),
                Expanded(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.lightGreen),
                    child: LinearProgressIndicator(
                      value: snashot.data['four'] != 0
                          ? (snashot.data['four'] / product.numOfRating)
                          : 0,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 24.0)),
                Expanded(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.yellow),
                    child: LinearProgressIndicator(
                      value: snashot.data['three'] != 0
                          ? (snashot.data['three'] / product.numOfRating)
                          : 0,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 24.0)),
                Expanded(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.orange),
                    child: LinearProgressIndicator(
                      value: snashot.data['two'] != 0
                          ? (snashot.data['two'] / product.numOfRating)
                          : 0,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.black54, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                    Icon(Icons.star, color: Colors.black12, size: 16.0),
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 24.0)),
                Expanded(
                  child: Theme(
                    data: ThemeData(accentColor: Colors.red),
                    child: LinearProgressIndicator(
                      value: snashot.data['one'] != 0
                          ? (snashot.data['one'] / product.numOfRating)
                          : 0,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(BuildContext context, Comment comment, Product product) {
    /// Review
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 5.0),
      child: Material(
        elevation: 12.0,
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: Container(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Text(comment.authorName.substring(0, 2).toUpperCase()),
                ),
                title: Text(comment.authorName, style: TextStyle()),
                subtitle: Text(comment.text, style: TextStyle()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.speaker_notes),
                    color: Colors.black,
                    onPressed: () {
                      print('with parent is press....');
                      Navigator.of(context).pushNamed(
                          ReplyCommentPage.routeName,
                          arguments: {'product': product, 'comment': comment});
                    },
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
