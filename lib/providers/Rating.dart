import 'package:flutter/foundation.dart';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RatingItem {
  //objectId is the leancloud objectId.
  final String objectId;
  final String userId;
  final String productId;
  final double rating;

  RatingItem({
    this.objectId,
    this.userId,
    this.productId,
    this.rating,
  });
}

class Rating with ChangeNotifier {
  final String authToken;
  final String userId;
  Rating(this.authToken, this.userId);
  //objectId, RatingItem
  Map<String, RatingItem> _items = {};

  Map<String, RatingItem> get items {
    return {..._items};
  }

  Future<void> addRating(String productId, double rating,
      [String objectId]) async {
    //add rating object to leancloud.
    AVObject avRating = AVObject('Rating');
    if (objectId != null) avRating.put('objectId', objectId);
    avRating.put('productId', productId);
    avRating.put('userId', this.userId);
    avRating.put('rating', rating);

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
    final ratingItem = json.decode(ratingResultString) as Map<String, dynamic>;
    if (_items.containsKey(userId) &&
        _items['objectId'] == ratingItem['objectId']) {
      _items.update(
          ratingItem['objectId'],
          (existingRatingItem) => RatingItem(
              userId: this.userId,
              productId: productId,
              rating: rating,
              objectId: ratingItem['objectId']));
    } else {
      _items.putIfAbsent(
          ratingItem['objectId'],
          () => RatingItem(
              userId: this.userId,
              productId: productId,
              rating: rating,
              objectId: ratingItem['objectId']));
    }
    notifyListeners();
  }

  RatingItem findById(String objectId) {
    return _items[objectId];
  }

  Future<RatingItem> fetchRatingItem(String productId) async {
    AVQuery avQuery = AVQuery('Rating');
    List<AVObject> ratings = await avQuery
        .whereEqualTo('userId', this.userId)
        .whereEqualTo('productId', productId)
        .find();
    if (ratings.length != 0) {
      notifyListeners();
      return RatingItem(
          objectId: ratings[0].get('objectId'),
          productId: ratings[0].get('productId'),
          userId: ratings[0].get('userId'),
          rating: ratings[0].get('rating'));
    } else {
      return null;
    }
  }

  void reverseRatingBack() {
    notifyListeners();
  }
}
