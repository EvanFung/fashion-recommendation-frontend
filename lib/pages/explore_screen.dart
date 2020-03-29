import 'package:flutter/material.dart';
import '../widgets/image_post.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<ImagePost> posts = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ImagePost(
            username: 'David',
            location: 'U.S',
            mediaUrl:
                'https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png',
            likes: 5,
            description: 'Hello this is my first post',
            postId: 'wjiojoi22a',
          ),
          ImagePost(
            username: 'David',
            location: 'U.S',
            mediaUrl:
                'https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png',
            likes: 5,
            description: 'Hello this is my first post',
            postId: 'wjiojoi22a',
          )
        ],
      ),
    );
  }
}
