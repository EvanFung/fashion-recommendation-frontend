import 'package:flutter/foundation.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/Product.dart';
import '../utils/api_url.dart';

/** productId is the objectId of the product, pId is the auto increament id of the product which used for recommendation */
class RatingItem {
  //objectId is the leancloud objectId.
  final String objectId;
  final String userId;
  final String productId;
  final double rating;
  final String pId;
  final String uId;

  RatingItem({
    this.objectId,
    this.userId,
    this.productId,
    this.rating,
    this.pId,
    this.uId,
  });
}

class Rating with ChangeNotifier {
  final String authToken;
  final String userId;
  final String uId;
  Rating(this.authToken, this.userId, this.uId);
  //objectId, RatingItem
  Map<String, RatingItem> _items = {};

  Map<String, RatingItem> get items {
    return {..._items};
  }

  Future<void> addRating(
      String productId, String pId, double rating, Product product,
      [String objectId]) async {
    try {
      product.numOfRating += 1;
      product.rating += rating;
      //add rating object to leancloud.
      AVObject avRating = AVObject('Rating');
      if (objectId != null) avRating.put('objectId', objectId);
      avRating.put('pId', pId);
      avRating.put('productId', productId);
      avRating.put('userId', this.userId);
      avRating.put('uId', this.uId);
      avRating.put('rating', rating);
      //No number of rating field and rating field for this json serialized.
      avRating.put('productStr', json.encode(product.toJson()));

      //update product #rating and total of the rating score, I will use REST API because there is no SDK for this operation
      final url =
          'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/classes/Product/$productId';
      final responseOnProduct = await http.put(url,
          headers: {
            "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
            "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
            "Content-Type": "application/json"
          },
          body: json.encode({
            "numOfRating": {"__op": "Increment", "amount": 1},
            "rating": {"__op": "Increment", "amount": rating}
          }));

      // print(responseOnProduct.body);

      final response = await avRating.save();
      //parsing it to map object
      final ratingResultString = json.decode(response.toString())['fields'];
      //cast it to map
      final ratingItem =
          json.decode(ratingResultString) as Map<String, dynamic>;
      if (_items.containsKey(userId) &&
          _items['objectId'] == ratingItem['objectId']) {
        _items.update(
            ratingItem['objectId'],
            (existingRatingItem) => RatingItem(
                  userId: this.userId,
                  productId: productId,
                  rating: rating,
                  uId: this.uId,
                  pId: pId,
                  objectId: ratingItem['objectId'],
                ));
      } else {
        _items.putIfAbsent(
            ratingItem['objectId'],
            () => RatingItem(
                userId: this.userId,
                productId: productId,
                uId: this.uId,
                pId: pId,
                rating: rating,
                objectId: ratingItem['objectId']));
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  RatingItem findById(String objectId) {
    return _items[objectId];
  }

  Future<RatingItem> fetchRatingItem(String productId) async {
    try {
      AVQuery avQuery = AVQuery('Rating');
      List<AVObject> ratings = await avQuery
          .whereEqualTo('userId', this.userId)
          .whereEqualTo('productId', productId)
          .find();
      if (ratings.length != 0) {
        // print(ratings[0].get('rating').runtimeType);
        return RatingItem(
          objectId: ratings[0].get('objectId'),
          productId: ratings[0].get('productId'),
          userId: ratings[0].get('userId'),
          rating: double.parse(ratings[0].get('rating').toString()),
        );
      } else {
        return null;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> getProductDifferentRating(
      String productId) async {
    try {
      final url = "${SeverAPI.chatbotServerAPIUrl}/rating?productId=$productId";
      final response = await http.get(url, headers: SeverAPI.authHeaders);
      Map<String, dynamic> ratingDetails =
          json.decode(response.body) as Map<String, dynamic>;
      return ratingDetails;
    } catch (error) {
      throw error;
    }
  }

  void reverseRatingBack() {
    notifyListeners();
  }
}
