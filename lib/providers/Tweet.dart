import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/image_utils.dart';
import '../utils/api_url.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class Tweet with ChangeNotifier {
  final String author;
  final String profilePicUrl;
  final String location;
  final String imageUrl;
  final String description;
  final int likes;
  final String createByID;
  final String imageID;

  Tweet({
    this.author,
    this.profilePicUrl,
    this.location,
    this.imageID,
    this.imageUrl,
    this.createByID,
    this.likes,
    this.description,
  });
}

class Tweets with ChangeNotifier {
  //session ID of the current user.
  final String authID;
  //object ID of the current user
  final String userID;
  //uId for recommendation algorithm
  final String uId;

  Tweets({
    this.authID,
    this.uId,
    this.userID,
  });

  Future<void> addTweet({imgae, createBy, likes, location, description}) async {
    //post a new tweet
    final responseInTweet = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/tweet',
      headers: SeverAPI.authHeaders,
      body: json.encode({
        "createBy": createBy,
        "image": imgae,
        "description": description,
        "likes": "0",
        "location": location
      }),
    );
    print(responseInTweet.body);
    Map<String, dynamic> tweetJson =
        json.decode(responseInTweet.body) as Map<String, dynamic>;
    final responseInSocial = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/sendStatus',
      headers: SeverAPI.authHeaders,
      body: json.encode({
        'followerSessionId': authID,
        'messages': {'event': "ADD_TWEET", 'data': tweetJson['tweet']}
      }),
    );
    print(responseInSocial.body);
  }

  Future<Map<String, dynamic>> uploadImage(File image, String fileName) async {
    //Upload image first.
    File compressedImage = await EImageUtils(image).compress(
      quality: 60,
    );
    File resizedImage = await EImageUtils(compressedImage).resize(width: 512);
    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/files/$fileName';
    final response = await http.post(
      url,
      headers: {
        "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
        "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
        "Content-Type": "image/jpg"
      },
      body: resizedImage.readAsBytesSync(),
    );
    final responsedData = json.decode(response.body) as Map<String, dynamic>;
    print(responsedData['objectId']);
    print(responsedData['url']);
    return responsedData;
  }
}
