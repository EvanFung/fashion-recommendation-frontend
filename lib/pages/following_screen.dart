import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FollowingScreen extends StatelessWidget {
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
            leading: const CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage: CachedNetworkImageProvider(
                  'http://lc-wwvo3d7k.cn-n1.lcfile.com/1bf010b01fd0097e1d83/default.jpeg'),
            ),
            title: Text('test1', style: boldStyle),
            subtitle: Text('I Love HK'),
            trailing: RaisedButton(
              onPressed: () {
                print('shushsuh');
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
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage: CachedNetworkImageProvider(
                  'http://lc-wwvo3d7k.cn-n1.lcfile.com/1bf010b01fd0097e1d83/default.jpeg'),
            ),
            title: Text('test3', style: boldStyle),
            subtitle: Text('I Love China'),
            trailing: RaisedButton(
              onPressed: () {
                print('shushsuh');
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
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     FlatButton(child: const Icon(Icons.thumb_up), onPressed: () {}),
          //     FlatButton(
          //         child: const Icon(Icons.comment),
          //         onPressed: () {
          //           // _likePost(postId);
          //         }),
          //   ],
          // ),
        ],
      ),
    );
  }
}
