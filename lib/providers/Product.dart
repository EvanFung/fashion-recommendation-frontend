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
  File image;
  double numOfRating;
  double rating;
  final String pId; //auto increament id of product. use for rating.
  bool isFavorite;
  bool isRated;

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
    this.pId,
    this.isRated = false,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'],
        createBy = json['createBy'],
        mainCategory = json['mainCategory'],
        subCategory = json['subCategory'],
        numOfRating = json['numOfRating'],
        isFavorite = json['isFavorite'],
        rating = json['rating'],
        pId = json['pId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'createBy': createBy,
        'mainCategory': mainCategory,
        'subCategory': subCategory,
        'numOfRating': numOfRating,
        'isFavorite': isFavorite,
        'rating': rating,
        'pId': pId,
      };

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void setRated() {
    isRated = true;
    notifyListeners();
  }
}
