import 'package:flutter/material.dart';
import '../widgets/image_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/Comment.dart';
import '../providers/Comments.dart';
import '../providers/Tweet.dart';

class ReplyTweetScreen extends StatefulWidget {
  static const routeName = '/reply-tweet-screen';

  @override
  _ReplyTweetScreenState createState() => _ReplyTweetScreenState();
}

class _ReplyTweetScreenState extends State<ReplyTweetScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode focusNode = new FocusNode();

  Future<List<Comment>> _fetchComment() async {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final tweet = data['Tweet'] as Tweet;
    List<Comment> comments = await Provider.of<Comments>(context, listen: false)
        .fetchCommentByTweetId(tweet.tweetObjectId);
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: _buildCommentListView(),
    );
  }

  Widget _buildCommentListView() {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final tweet = data['Tweet'] as Tweet;
    return Container(
      height: MediaQuery.of(context).size.height * 80,
      width: double.infinity,
      child: ListView(
        children: <Widget>[
          ImagePost(
            username: tweet.author,
            location: tweet.location,
            mediaUrl: tweet.imageUrl,
            likes: tweet.likes,
            description: tweet.description,
            postId: tweet.objectID,
            profileUrl: tweet.profilePicUrl,
            tweetId: tweet.tweetObjectId,
            isInComment: true,
          ),
          Divider(
            thickness: 5.0,
          ),
          FutureBuilder(
            future: _fetchComment(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                } else {
                  List<Comment> comments = snapshot.data;
                  List<Widget> commentWidget = comments
                      .map((comment) => _buildComment(comment))
                      .toList();
                  return Column(
                    children: commentWidget,
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white10,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(comment.authorProfilePicUrl),
            ),
            title: Text(
              comment.authorName,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                comment.text,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
