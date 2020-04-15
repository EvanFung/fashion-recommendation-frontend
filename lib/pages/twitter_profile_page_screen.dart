import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Tweet.dart';
import '../providers/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/image_post.dart';

class TwitterProfilePage extends StatefulWidget {
  static const routeName = '/twitter-profile-page';
  @override
  _TwitterProfilePageState createState() => _TwitterProfilePageState();
}

class _TwitterProfilePageState extends State<TwitterProfilePage> {
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  var _isInit = true;
  var _isLoading = false;

  List<dynamic> followers;
  List<dynamic> followings;
  List<Tweet> posts;

  String username;
  String profilePic;
  String bio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    //it will run after the app fully operate.
    final thisTweetUserId =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await getFollowerAndFollowing();
      await getThisTweetUser(thisTweetUserId['createById']);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future editProfile() {
    return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('Edit Profile'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Editing does not work yet, sorry'),
              ],
            ),
          ),
        ));
  }

  followUser() {
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
    final thisTweetUserId =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Provider.of<Tweets>(context, listen: false)
        .follow(thisTweetUserId['createById']);
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
    final thisTweetUserId =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    Provider.of<Tweets>(context, listen: false)
        .unfollow(thisTweetUserId['createById']);
  }

  Widget buildStateColumn(String label, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Container buildProfileFollowButton(
    String currentUserId,
    String thisTweetUserId,
  ) {
    if (followings.length > 0) {
      followings.forEach((user) {
        if (user['objectId'] == thisTweetUserId) {
          setState(() {
            isFollowing = true;
          });
        }
      });
    }

    if (currentUserId == thisTweetUserId) {
      return buildFollowButton(
        text: "Edit Profile",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: editProfile,
      );
    }
    //already following user - should show unfollow button
    if (isFollowing) {
      return buildFollowButton(
        text: "Unfollow",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    //does not follow user - should show follow button
    if (!isFollowing) {
      return buildFollowButton(
        text: "Follow",
        backgroundcolor: Colors.blue,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: followUser,
      );
    }
    // loding button

    return buildFollowButton(
      text: "loading...",
      backgroundcolor: Colors.white,
      textColor: Colors.black,
      borderColor: Colors.grey,
    );
  }

  Container buildFollowButton({
    String text,
    Color backgroundcolor,
    Color textColor,
    Color borderColor,
    Function function,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundcolor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5.0)),
          alignment: Alignment.center,
          child: Text(text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          width: 250.0,
          height: 27.0,
        ),
      ),
    );
  }

  Row buildImageViewButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: null,
        ),
      ],
    );
  }

  Container buildImageGrid(List<Tweet> tweets) {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tweets.map((tweet) {
          print(tweet.tweetObjectId);
          print(tweet.author);
          print(tweet.imageUrl);
          print(tweet.description);
          print(tweet.likes);
          print(tweet.objectID);
          print(tweet.createByID);
          print(tweet.profilePicUrl);
          return ImageTile(
              tweet,
              ImagePost(
                tweetId: tweet.tweetObjectId,
                isInComment: true,
                mediaUrl: tweet.imageUrl,
                location: tweet.location,
                description: tweet.description,
                likes: tweet.likes,
                postId: tweet.objectID,
                createById: tweet.createByID,
                profileUrl: tweet.profilePicUrl,
                username: tweet.author,
              ));
        }).toList(),
        // <Widget>[
        //   GridTile(child: ImageTile()),
        // ],
      ),
    );
  }

  Future<void> getFollowerAndFollowing() async {
    //get followee info
    await Provider.of<Tweets>(context, listen: false).queryFollowingList();
    //get following info
    await Provider.of<Tweets>(context, listen: false).queryFollowersList();
    final followersUser = Provider.of<Tweets>(context, listen: false).followers;
    final followingsUser =
        Provider.of<Tweets>(context, listen: false).followings;

    setState(() {
      followings = followingsUser;
      followers = followersUser;
    });
  }

  Future<List<Tweet>> getPost(String userId) async {
    List<Tweet> tweets =
        await Provider.of<Tweets>(context, listen: false).queryTweets(userId);
    // setState(() {
    //   postCount = posts;
    // });
    return tweets;
  }

  Future<void> getThisTweetUser(String userId) async {
    await Provider.of<Tweets>(context, listen: false).getThisTweetUser(userId);
    final usernameData =
        Provider.of<Tweets>(context, listen: false).thisTweetUsername;
    final profilePicUrl =
        Provider.of<Tweets>(context, listen: false).thisTweetProfilePic;
    final bioData = Provider.of<Tweets>(context, listen: false).thisTweetBio;
    setState(() {
      username = usernameData;
      profilePic = profilePicUrl;
      bio = bioData;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<Auth>(context, listen: false).userId;

    final thisTweetUserId =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final postCount =
        Provider.of<Tweets>(context, listen: false).currentPost.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tester Profile',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                CachedNetworkImageProvider(profilePic),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    //build state column (post , followers, following)
                                    buildStateColumn('Posts', postCount),
                                    buildStateColumn(
                                        'Followers', followers.length),
                                    buildStateColumn(
                                        'Following', followings.length),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    //build profile follow button
                                    buildProfileFollowButton(currentUserId,
                                        thisTweetUserId['createById']),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 15.0,
                        ),
                        child: Text(
                          username == null ? 'N/A' : username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1.0,
                          left: 15.0,
                        ),
                        child: bio == null ? Container() : Text(bio),
                      ),
                    ],
                  ),
                ),
                Divider(),
                buildImageViewButtonBar(),
                Divider(height: 0.0),

                // FutureBuilder(),
                FutureBuilder(
                  future: getPost(thisTweetUserId['createById']),
                  builder: (context, snapshot) {
                    if (ConnectionState.done == snapshot.connectionState) {
                      if (snapshot.hasError) {
                        return Text('NETWORK ERROR, PLEASE TRY AGAIN LATER');
                      } else {
                        return buildImageGrid(snapshot.data);
                      }
                    } else {
                      //request not done
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final Tweet tweet;
  final ImagePost imagePost;

  ImageTile(this.tweet, this.imagePost);

  // final ImagePost imagePost;

  // ImageTile(this.imagePost);

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Center(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Photo'),
            ),
            body: new ListView(
              children: <Widget>[
                new Container(
                  child: imagePost,
                ),
              ],
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => clickedImage(context),
      child: new Image.network(
        tweet.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
