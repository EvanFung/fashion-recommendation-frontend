import 'package:flutter/material.dart';

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
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
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

  Container buildProfileFollowButton() {
    //if current user id == profile id(userid)

    //already following user - should show unfollow button

    //does not follow user - should show follow button

    // loding button

    return buildFollowButton(
      text: 'Follow',
      backgroundcolor: Colors.blue,
      borderColor: Colors.blue,
      textColor: Colors.white,
      function: followUser,
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

  Container buildImageGrid() {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          GridTile(child: ImageTile()),
          GridTile(child: ImageTile()),
          GridTile(child: ImageTile()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tester Profile',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
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
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              //build state column (post , followers, following)
                              buildStateColumn('Posts', 5),
                              buildStateColumn('Followers', 500),
                              buildStateColumn('Following', 1),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //build profile follow button
                              buildProfileFollowButton(),
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
                      'Evan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 1.0,
                    left: 15.0,
                  ),
                  child: Text('I LOVE HK'),
                ),
              ],
            ),
          ),
          Divider(),
          buildImageViewButtonBar(),
          Divider(height: 0.0),
          buildImageGrid(),
        ],
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  // final ImagePost imagePost;

  // ImageTile(this.imagePost);

  // clickedImage(BuildContext context) {
  //   Navigator
  //       .of(context)
  //       .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
  //     return new Center(
  //       child: new Scaffold(
  //           appBar: new AppBar(
  //             title: new Text('Photo'),
  //           ),
  //           body: new ListView(
  //             children: <Widget>[
  //               new Container(
  //                 child: imagePost,
  //               ),
  //             ],
  //           )),
  //     );
  //   }));
  // }

  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => print('shsudhushu'),
      child: new Image.network(
        'http://lc-wwvo3d7k.cn-n1.lcfile.com/0QTS3UFektwFS0TcxzvcQ1tdcr4f2JJPjSBxWxyQ.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
