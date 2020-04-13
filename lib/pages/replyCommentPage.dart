import 'package:fashion/pages/newComment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Comments.dart';
import '../providers/Comment.dart';
import '../providers/Product.dart';
import '../providers/auth.dart';

class ReplyCommentPage extends StatelessWidget {
  static const routeName = '/reply-comment';
  Future<List<Comment>> _fetchReply(
      BuildContext context, String parentId) async {
    return await Provider.of<Comments>(context)
        .fetchCommentByParentId(parentId);
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final userId = Provider.of<Auth>(context).userId;
    Product product = data['product'] as Product;
    Comment parentComment = data['comment'] as Comment;
    String commentType = data['type'];

    // _fetchReply(context, parentComment.objectId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply to ${parentComment.authorName.toUpperCase()}'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white10,
              padding: EdgeInsets.only(top: 10.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                      'https://www.inovex.de/blog/wp-content/uploads/2019/01/Flutter-1-1.png'),
                ),
                title: Text(
                  parentComment.authorName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    parentComment.text,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.speaker_notes),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(NewComment.routeName, arguments: {
                        'product': product,
                        'comment': parentComment,
                        'type': commentType,
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 4.0,
            ),
            // _buildReplyComment(parentComment),
            FutureBuilder(
              future: _fetchReply(context, parentComment.objectId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //request done
                  if (snapshot.hasError) {
                    return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                  } else {
                    // print(snapshot.data);

                    List<Comment> comments = snapshot.data;
                    List<Widget> reviews = comments
                        .map((comment) =>
                            _buildReplyComment(context, comment, product))
                        .toList();
                    return Column(
                      children: reviews,
                    );
                  }
                } else {
                  //request not done
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyComment(
    BuildContext context,
    Comment comment,
    Product product,
  ) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white10,
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                  'https://www.inovex.de/blog/wp-content/uploads/2019/01/Flutter-1-1.png'),
            ),
            title: Text(
              comment.authorName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                comment.text,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.black,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.speaker_notes),
                color: Colors.black,
                onPressed: () {
                  print('with parent is press....');
                  Navigator.of(context).pushNamed(ReplyCommentPage.routeName,
                      arguments: {'product': product, 'comment': comment});
                },
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
