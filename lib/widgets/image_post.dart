import 'package:fashion/pages/replyCommentPage.dart';
import 'package:flutter/material.dart';
import '../pages/twitter_profile_page_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/Tweet.dart';
import 'package:provider/provider.dart';
import '../pages/reply_tweet.dart';
import '../pages/newComment.dart';

class ImagePost extends StatefulWidget {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final int likes;
  final String postId;
  final String createById;
  final String tweetId;
  final String profileUrl;
  final bool isInComment;
  ImagePost({
    this.mediaUrl,
    this.username,
    this.location,
    this.description,
    this.likes,
    this.postId,
    this.createById,
    this.tweetId,
    this.profileUrl,
    this.isInComment,
  });

  @override
  _ImagePostState createState() => _ImagePostState(
        this.mediaUrl,
        this.username,
        this.location,
        this.description,
        this.likes,
        this.postId,
        this.createById,
        this.tweetId,
        this.profileUrl,
        this.isInComment,
      );
}

class _ImagePostState extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  int likes;
  //status id
  final String postId;
  final String createById;
  //tweet id
  final String tweetId;
  final String profileUrl;

  bool _isLiked = false;
  bool isInComment = false;

  _ImagePostState(
      this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.createById,
      this.tweetId,
      this.profileUrl,
      this.isInComment);

  TextStyle boldStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(profileUrl),
            ),
            title: GestureDetector(
              onTap: () {
                // print(this.createById);
                Navigator.of(context).pushNamed(
                  TwitterProfilePage.routeName,
                  arguments: {"createById": this.createById},
                );
              },
              child: Text(this.username, style: boldStyle),
            ),
            subtitle: Text(this.location),
            trailing: const Icon(Icons.more_vert),
          ),
          Image.network(
            mediaUrl,
            fit: BoxFit.fill,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _likePost(tweetId);
                  }),
              FlatButton(
                  child: const Icon(Icons.comment),
                  onPressed: () {
                    if (isInComment) {
                      Navigator.of(context)
                          .pushNamed(NewComment.routeName, arguments: {
                        'product': null,
                        'comment': null,
                        'tweet': Tweet(
                          description: description,
                          author: username,
                          location: location,
                          profilePicUrl: profileUrl,
                          objectID: postId,
                          tweetObjectId: tweetId,
                          imageUrl: mediaUrl,
                        ),
                        'type': 'tweet'
                      });
                    } else {
                      // is in explore page, then redirect to reply tweet page.
                      Navigator.of(context)
                          .pushNamed(ReplyTweetScreen.routeName, arguments: {
                        'Tweet': Tweet(
                          objectID: postId,
                          tweetObjectId: tweetId,
                          location: location,
                          likes: likes,
                          createByID: createById,
                          imageUrl: mediaUrl,
                          description: description,
                          profilePicUrl: profileUrl,
                          author: username,
                        )
                      });
                    }
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "$likes likes",
                  style: boldStyle,
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "$username ",
                    style: boldStyle,
                  )),
              Expanded(child: Text(description)),
            ],
          )
        ],
      ),
    );
  }

  void _likePost(String tweetId) {
    Provider.of<Tweets>(context, listen: false).likes(tweetId).then((_) {
      setState(() {
        _isLiked = true;
        likes = likes + 1;
      });
    });
  }
}
