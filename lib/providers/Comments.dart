import 'package:flutter/foundation.dart';
import './Comment.dart';
import 'package:http/http.dart' as http;
import '../utils/api_url.dart';
import 'dart:convert';
import 'package:leancloud_flutter_plugin/leancloud_flutter_plugin.dart';

class Comments with ChangeNotifier {
  final String authToken;
  final String userId;
  final String uId;
  List<Comment> _items = [];
  Comments(this.authToken, this.userId, this.uId);

  List<Comment> get items {
    return [..._items];
  }

  //Find the comment with no parent.
  Future<List<Comment>> fetchCommentByProductId(String productId) async {
    final response = await http.get(
        SeverAPI.chatbotServerAPIUrl + '/comment?productId=$productId',
        headers: SeverAPI.authHeaders);
    // print(json.decode(response.body));
    final List<Comment> loadedComment = [];
    Map<String, dynamic> responseBody = json.decode(response.body);
    //Get the list of comment
    List<dynamic> commentsJson = responseBody['comments'] as List<dynamic>;
    // print(commentsJson);
    commentsJson
        .where((comment) => comment['parentId'] == null)
        .forEach((comment) {
      loadedComment.add(Comment(
          objectId: comment['objectId'],
          productId: comment['productId']['objectId'],
          authorId: comment['authorId']['objectId'],
          parentId: comment['parentId'] != null
              ? comment['parentId']['objectId']
              : null,
          authorName: comment['authorId']['username'],
          authorProfilePicUrl: comment['authorId']['profilePic']['url'],
          text: comment['text']));
    });
    return loadedComment;
  }

  //Find the comment with their parent's id
  Future<List<Comment>> fetchCommentByParentId(String parentId) async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/comment/parent',
      headers: SeverAPI.authHeaders,
      body: json.encode({'parentId': parentId}),
    );
    final List<Comment> loadedComment = [];
    Map<String, dynamic> responseBody = json.decode(response.body);
    //Get the list of comment
    List<dynamic> commentsJson = responseBody['comments'] as List<dynamic>;
    commentsJson
        .where((comment) => comment['parentId'] != null)
        .forEach((comment) {
      loadedComment.add(Comment(
          objectId: comment['objectId'],
          productId: comment['productId']['objectId'],
          authorId: comment['authorId']['objectId'],
          parentId: comment['parentId']['objectId'],
          authorName: comment['authorId']['username'],
          authorProfilePicUrl: comment['authorId']['profilePic']['url'],
          text: comment['text']));
    });
    return loadedComment;
  }

  Future<void> addComment(Comment comment) async {
    await http.post(SeverAPI.chatbotServerAPIUrl + '/comment/post',
        headers: SeverAPI.authHeaders,
        body: json.encode({
          'productId': comment.productId,
          'parentId': comment.parentId,
          'authorId': comment.authorId,
          'text': comment.text,
        }));
  }
}
