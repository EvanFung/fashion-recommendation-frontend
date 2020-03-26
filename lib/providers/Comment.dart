import 'package:flutter/foundation.dart';

class Comment with ChangeNotifier {
  final String productId;
  final String parentId;
  final String authorId;
  final String text;
  final String objectId;
  final String authorName;

  Comment({
    @required this.productId,
    @required this.authorId,
    @required this.text,
    @required this.objectId,
    this.parentId,
    this.authorName,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        parentId = json['parentId'],
        authorId = json['authorId'],
        objectId = json['objectId'],
        authorName = json['authorName'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'parentId': parentId,
        'authorId': authorId,
        'objectId': objectId,
        'authorName': authorName,
        'text': text
      };
}
