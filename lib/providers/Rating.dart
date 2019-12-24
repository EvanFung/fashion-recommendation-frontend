import 'package:flutter/foundation.dart';

class RatingItem {
  final String userId;
  final String productId;
  final double rating;

  RatingItem({
    this.userId,
    this.productId,
    this.rating,
  });
}

class Rating with ChangeNotifier {
  final String authToken;
  final String userId;
  Rating(this.authToken, this.userId);
}
