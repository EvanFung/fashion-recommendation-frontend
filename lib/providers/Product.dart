import 'package:flutter/foundation.dart';
import 'dart:io';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String createBy;
  final String mainCategory;
  final String subCategory;
  final File image;
  final int numOfRating;
  final double rating;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.createBy,
    this.mainCategory,
    this.subCategory,
    this.image,
    this.isFavorite = false,
    this.numOfRating,
    this.rating,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
