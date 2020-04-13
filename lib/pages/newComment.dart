import 'package:fashion/providers/Comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Comments.dart';
import '../providers/Product.dart';
import '../providers/auth.dart';
import '../providers/Tweet.dart';

class NewComment extends StatefulWidget {
  static const routeName = '/new-comment';

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final TextEditingController tweetController = TextEditingController();
  bool _isPostButtonDisabled;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPostButtonDisabled = false;
  }

  void _addComment(
    Product product,
    String userId,
    Comment parentComment,
    String type,
    Tweet tweet,
  ) {
    setState(() {
      _isPostButtonDisabled = true;
    });
    Provider.of<Comments>(context)
        .addComment(Comment(
      productId: product == null ? null : product.id,
      authorId: userId,
      parentId: parentComment == null ? null : parentComment.objectId,
      text: tweetController.text,
      type: type,
      tweetId: tweet == null ? null : tweet.tweetObjectId,
    ))
        .then((onValue) {
      setState(() {
        _isPostButtonDisabled = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final userId = Provider.of<Auth>(context).userId;
    Product product = data['product'] as Product;
    Comment parentComment = data['comment'] as Comment;
    String commentType = data['type'];
    Tweet tweet = data['tweet'] as Tweet;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white24,
        brightness: Brightness.light,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Color.fromRGBO(29, 162, 240, 1.0),
          icon: Icon(
            Icons.close,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: RaisedButton(
              onPressed: _isPostButtonDisabled
                  ? null
                  : () => _addComment(
                      product, userId, parentComment, commentType, tweet),
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              color: Color.fromRGBO(29, 162, 240, 1.0),
              child: Text(
                'POST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56.0,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(101, 118, 133, 0.5),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: Color.fromRGBO(230, 236, 240, 1.0),
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  margin: EdgeInsets.only(right: 24.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 172, 237, 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                Container(
                  width: size.width * 0.7,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: tweetController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.0,
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0.0),
                      labelText: 'Add comment',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(20, 23, 2, 1.0),
                      ),
                    ),
                    autocorrect: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
