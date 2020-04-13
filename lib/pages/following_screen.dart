import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/Tweet.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _isFollowing = true;

  @override
  void didChangeDependencies() async {
    //it will run after the app fully operate.
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tweets>(context, listen: false)
          .queryFollowingList()
          .then((_) {
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

  TextStyle boldStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  Widget buildFollowingButton(String followeeId) {
    if (_isFollowing) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _isFollowing = !_isFollowing;
          });
          Provider.of<Tweets>(context, listen: false).unfollow(followeeId);
        },
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: Colors.blueAccent,
        child: Text(
          'Following',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _isFollowing = !_isFollowing;
          });
          Provider.of<Tweets>(context, listen: false).follow(followeeId);
        },
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: Colors.white,
        child: Text(
          'Follow',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> users =
        Provider.of<Tweets>(context, listen: false).followings;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: users == null
                    ? Container()
                    : users
                        .map(
                          (user) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple,
                                backgroundImage: CachedNetworkImageProvider(
                                  user['profilePic']['url'],
                                ),
                              ),
                              title: user['username'] == null
                                  ? Container()
                                  : Text(user['username'], style: boldStyle),
                              subtitle: user['bio'] == null
                                  ? Container()
                                  : Text(user['bio']),
                              trailing: buildFollowingButton(user['objectId'])),
                        )
                        .toList()),
          );
  }
}
