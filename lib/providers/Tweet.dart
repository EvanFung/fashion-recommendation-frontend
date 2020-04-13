import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/image_utils.dart';
import '../utils/api_url.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class Tweet with ChangeNotifier {
  //name of the author
  final String author;
  final String profilePicUrl;
  final String location;
  final String imageUrl;
  final String description;
  final int likes;
  final String createByID;
  final String imageID;
  final String objectID;
  final String tweetObjectId;

  Tweet({
    this.objectID, //is the status objectId, not tweet id
    this.author,
    this.profilePicUrl,
    this.location,
    this.imageID,
    this.imageUrl,
    this.createByID,
    this.likes,
    this.description,
    this.tweetObjectId,
  });
}

class Tweets with ChangeNotifier {
  //session ID of the current user.
  final String authID;
  //object ID of the current user
  final String userID;
  //uId for recommendation algorithm
  final String uId;
  final String username;

  List<dynamic> followings = [];

  List<dynamic> followers = [];

  List<Tweet> _items = [];

  List<Tweet> _currentPost = [];

  int _postCount;

  String _thisTweetUsername;
  String _thisTweetProfilePic;
  String _thisTweetBio;

  String _thisTweetPostCount;

  Tweets({
    this.authID,
    this.uId,
    this.userID,
    this.username,
  });

  List<Tweet> get items {
    return _items;
  }

  List<Tweet> get currentPost {
    return _currentPost;
  }

  String get thisTweetUsername {
    return _thisTweetUsername;
  }

  String get thisTweetProfilePic {
    return _thisTweetProfilePic;
  }

  String get thisTweetBio {
    return _thisTweetBio;
  }

  int get postCount {
    return _postCount;
  }

  Future<void> addTweet({
    image,
    createBy,
    likes,
    location,
    description,
    imageUrl,
  }) async {
    //post a new tweet
    final responseInTweet = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/tweet',
      headers: SeverAPI.authHeaders,
      body: json.encode({
        "createBy": createBy, //user objectId
        "image": image, //image objectId
        "description": description,
        "likes": "0",
        "location": location
      }),
    );
    // print(responseInTweet.body);
    Map<String, dynamic> tweetJson =
        json.decode(responseInTweet.body) as Map<String, dynamic>;

    final responseInSocial = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/sendStatus',
      headers: SeverAPI.authHeaders,
      body: json.encode({
        'followerSessionId': authID,
        'tweet': tweetJson['tweet'],
      }),
    );
    // print(responseInSocial.body);
    final responseData =
        json.decode(responseInSocial.body) as Map<String, dynamic>;

    String objectID = responseData['result']['id'];
    String author = responseData['thisTweet']['createBy']['username'];
    String profilePicUrl =
        responseData['thisTweet']['createBy']['profilePic']['url'];
    String imageUrl = responseData['thisTweet']['image']['url'];
    String tweetId = responseData['thisTweet']['objectId'];
    _items.add(Tweet(
      objectID: objectID,
      author: author,
      profilePicUrl: profilePicUrl,
      imageUrl: imageUrl,
      imageID: image,
      location: location,
      likes: 0,
      description: description,
      createByID: createBy,
      tweetObjectId: tweetId,
    ));
    notifyListeners();
  }

  Future<Map<String, dynamic>> uploadImage(File image, String fileName) async {
    //Upload image first.
    File compressedImage = await EImageUtils(image).compress(
      quality: 60,
    );
    var url = 'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/files/$fileName';
    final response = await http.post(
      url,
      headers: {
        "X-LC-Id": "WWVO3d7KG8fUpPvTY9mt1OT5-gzGzoHsz",
        "X-LC-Key": "2nDU7yqQoMpsGMTFbWYTdxgG",
        "Content-Type": "image/jpg"
      },
      body: compressedImage.readAsBytesSync(),
    );
    final responsedData = json.decode(response.body) as Map<String, dynamic>;
    // print(responsedData['objectId']);
    // print(responsedData['url']);
    return responsedData;
  }

  //query inbox[status]
  Future<void> queryStatus() async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/queryInbox',
      headers: SeverAPI.authHeaders,
      body: json.encode({'followerSessionId': authID}),
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    // print(responseData['statuses'][0]['id']);
    final statuses = responseData['statuses'] as List;
    List<Tweet> loadedTweet = [];
    statuses.forEach((status) {
      String authorName = status['data']['authorName'];
      String imageUrl = status['data']['image'];
      String description = status['data']['message'];
      String profilePic = status['data']['source']['profilePic']['url'];
      // int likes = status['data']['likes'];
      String location = status['data']['location'];
      String imageID = status['data']['imageID'];
      String createByID = status['data']['creatorID'];
      String objectID = status['id'];
      String tweetId = status['data']['tweet']['objectId'];
      int likes = status['data']['tweet']['likes'];
      // print(status['data']['tweet']['likes']);

      loadedTweet.add(Tweet(
          author: authorName,
          description: description,
          imageID: imageID,
          createByID: createByID,
          likes: likes,
          location: location,
          profilePicUrl: profilePic,
          imageUrl: imageUrl,
          objectID: objectID,
          tweetObjectId: tweetId));
    });
    //update provider
    _items = loadedTweet;
    notifyListeners();
  }

  Future<void> queryFollowingList() async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/queryFollowees',
      headers: SeverAPI.authHeaders,
      body: json.encode({'followerSessionId': authID}),
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final loadedFollowees = responseData['followees'] as List<dynamic>;
    followings = loadedFollowees;
    print(followings);
    notifyListeners();
  }

  Future<void> queryFollowersList() async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/queryFollower',
      headers: SeverAPI.authHeaders,
      body: json.encode({'followerSessionId': authID}),
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final loadedFollowers = responseData['followers'] as List<dynamic>;
    followers = loadedFollowers;
    notifyListeners();
  }

  //query user's tweets
  Future<List<Tweet>> queryTweets(String userId) async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/tweet/userId',
      headers: SeverAPI.authHeaders,
      body: json.encode({'userId': userId}),
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final tweets = responseData['tweets'] as List<dynamic>;
    List<Tweet> loadedTweets = [];

    if (tweets.length > 0) {
      tweets.forEach((tweet) {
        loadedTweets.add(Tweet(
            createByID: tweet['createBy']['objectId'],
            author: tweet['createBy']['username'],
            imageID: tweet['image']['objectId'],
            likes: tweet['likes'],
            location: tweet['location'],
            profilePicUrl: tweet['createBy']['profilePic']['url'],
            imageUrl: tweet['image']['url'],
            objectID: tweet['objectId']));
      });
      _currentPost = loadedTweets;
      _postCount = tweets.length;
      notifyListeners();
    }

    return loadedTweets;
  }

  Future<void> getThisTweetUser(String userId) async {
    final response = await http.get(
        'https://wwvo3d7k.lc-cn-n1-shared.com/1.1/users/$userId',
        headers: SeverAPI.authHeaders);
    final responseData = json.decode(response.body);
    _thisTweetUsername = responseData['username'];
    _thisTweetBio = responseData['bio'];
    _thisTweetProfilePic = responseData['profilePic']['url'];
    notifyListeners();
  }

  //id of the user who was followed.
  Future<void> follow(String followeeId) async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/follow',
      headers: SeverAPI.authHeaders,
      body: json.encode(
        {
          'followerSessionId': authID,
          'followeeId': followeeId,
        },
      ),
    );

    final responseData = json.decode(response.body);
    print(responseData);
  }

  Future<void> unfollow(String followeeId) async {
    final response = await http.post(
      SeverAPI.chatbotServerAPIUrl + '/social/unfollow',
      headers: SeverAPI.authHeaders,
      body: json.encode(
        {
          'followerSessionId': authID,
          'followeeId': followeeId,
        },
      ),
    );

    final responseData = json.decode(response.body);
    print(responseData);
  }

  Future<void> likes(String tweetId) async {
    final response = await http.post(
        SeverAPI.chatbotServerAPIUrl + '/tweet/like',
        headers: SeverAPI.authHeaders,
        body: json.encode({"tweetID": tweetId}));

    final responseData = json.decode(response.body);
    print(responseData);
  }
}
