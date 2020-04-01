import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Tweet.dart';
import '../widgets/image_post.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<ImagePost> posts = [];
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tweets>(context, listen: false).queryStatus().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tweetData = Provider.of<Tweets>(context).items;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: ListView(
                children: tweetData == null
                    ? Container()
                    : tweetData.map((tweet) {
                        print(tweet.author);
                        print(tweet.location);
                        print(tweet.imageUrl);
                        print(tweet.likes);
                        print(tweet.description);
                        print(tweet.objectID);
                        return ImagePost(
                          username: tweet.author,
                          location: tweet.location,
                          mediaUrl: tweet.imageUrl,
                          likes: int.parse(tweet.likes),
                          description: tweet.description,
                          postId: tweet.objectID,
                        );
                      }).toList()
                // <Widget>[
                //   ImagePost(
                //     username: 'David',
                //     location: 'U.S',
                //     mediaUrl:
                //         'https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png',
                //     likes: 5,
                //     description: 'Hello this is my first post',
                //     postId: 'wjiojoi22a',
                //   ),
                //   ImagePost(
                //     username: 'David',
                //     location: 'U.S',
                //     mediaUrl:
                //         'https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png',
                //     likes: 5,
                //     description: 'Hello this is my first post',
                //     postId: 'wjiojoi22a',
                //   )
                // ],
                ),
          );
  }
}
