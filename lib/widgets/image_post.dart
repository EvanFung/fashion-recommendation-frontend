import 'package:flutter/material.dart';
import '../pages/twitter_profile_page_screen.dart';

class ImagePost extends StatefulWidget {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final int likes;
  final String postId;
  ImagePost(
      {this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId});

  @override
  _ImagePostState createState() => _ImagePostState(this.mediaUrl, this.username,
      this.location, this.description, this.likes, this.postId);
}

class _ImagePostState extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final int likes;
  final String postId;

  _ImagePostState(
    this.mediaUrl,
    this.username,
    this.location,
    this.description,
    this.likes,
    this.postId,
  );

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
            leading: const CircleAvatar(),
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(TwitterProfilePage.routeName);
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
              FlatButton(child: const Icon(Icons.thumb_up), onPressed: () {}),
              FlatButton(
                  child: const Icon(Icons.comment),
                  onPressed: () {
                    _likePost(postId);
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

  void _likePost(String postId) {
    // reference.document(postId).updateData({'likes': likes + 1}); //make this more error proof maybe with cloud functions
  }
}
