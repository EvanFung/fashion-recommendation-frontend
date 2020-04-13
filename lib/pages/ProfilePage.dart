import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../pages/UserProductPage.dart';
import '../pages/OrdersPage.dart';
import '../providers/PagesInfo.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../pages/chatPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import '../providers/auth.dart';
import 'dart:math';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                // child: Icon(icon),
              ),
              Expanded(
                  child: Column(
                children: children,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatefulWidget {
  _ContactItem({
    Key key,
    this.icon,
    this.lines,
    this.tooltip,
    this.onPressed,
    final this.type,
  })  : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final Function onPressed;
  //user table field
  final String type;

  bool isChange = false;

  @override
  __ContactItemState createState() => __ContactItemState();
}

class __ContactItemState extends State<_ContactItem> {
  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    final List<Widget> columnChildren = widget.lines
        .sublist(0, widget.lines.length - 1)
        .map<Widget>((String line) {
      if (widget.isChange) {
        return TextField(
          controller: editingController,
          decoration: InputDecoration(labelText: line),
        );
      } else {
        return Text(line);
      }
    }).toList();
    if (!widget.isChange) {
      columnChildren.add(Text(widget.lines.last));
    }
    final List<Widget> rowChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
      ),
    ];
    if (widget.icon != null &&
        (widget.type == 'username' || widget.type == 'bio')) {
      rowChildren.add(SizedBox(
        width: 72.0,
        child: IconButton(
          icon: const Icon(
            Icons.create,
          ),
          onPressed: () {
            setState(() {
              widget.isChange = !widget.isChange;
              print(widget.isChange);
              print(editingController.text);
              if (widget.isChange == false) {
                Provider.of<Auth>(context)
                    .updateUser(widget.type, editingController.text);
              }
              widget.onPressed();
            });
          },
        ),
      ));
    }
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        ),
      ),
    );
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  // upload image
  File _storedImage;
  DateTime _birthDay;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _storedImage = imageFile;
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = await path.basename(imageFile.path);

    final saveImage = await imageFile.copy('${appDir.path}/$fileName');
    await Provider.of<Auth>(context).uploadProfilePic(imageFile, fileName);
  }

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<Auth>(context).username;
    String uId = Provider.of<Auth>(context).uId;
    String email = Provider.of<Auth>(context).email;
    String bio = Provider.of<Auth>(context).bio;
    String profilePicUrl = Provider.of<Auth>(context).profilePicUrl;
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: _appBarBehavior == AppBarBehavior.pinned,
            floating: _appBarBehavior == AppBarBehavior.floating ||
                _appBarBehavior == AppBarBehavior.snapping,
            snap: _appBarBehavior == AppBarBehavior.snapping,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.create,
                ),
                tooltip: 'Edit',
                onPressed: _takePicture
                //     () {
                //   _scaffoldKey.currentState.showSnackBar(const SnackBar(
                //     content: Text("Editing isn't supported in this screen."),
                //   ));
                // }
                ,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                username == null ? 'n/a' : username,
                style: TextStyle(color: Colors.black),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  profilePicUrl != null
                      ? Image.network(profilePicUrl,
                          fit: BoxFit.cover, height: _appBarHeight)
                      : Image.asset(
                          'assets/images/people2.jpeg',
                          fit: BoxFit.cover,
                          height: _appBarHeight,
                        ),
                  // _storedImage != null
                  //     ? Image.file(
                  //         _storedImage,
                  //         fit: BoxFit.cover,
                  //         height: _appBarHeight,
                  //       )
                  //     : Image.asset(
                  //         'assets/images/people2.jpeg',
                  //         fit: BoxFit.cover,
                  //         height: _appBarHeight,
                  //       ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: _ContactCategory(
                  icon: Icons.call,
                  children: <Widget>[
                    _ContactItem(
                      icon: Icons.message,
                      tooltip: 'Send message',
                      type: 'username',
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('Username has been updated!'),
                        ));
                      },
                      lines: <String>[
                        'Username',
                        username == null ? 'n/a' : username,
                      ],
                    ),
                    _ContactItem(
                      icon: Icons.message,
                      tooltip: 'Send message',
                      type: 'uId',
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('Username has been updated!'),
                        ));
                      },
                      lines: <String>[
                        'User ID',
                        uId == null ? 'n/a' : uId,
                      ],
                    ),
                    _ContactItem(
                      icon: Icons.message,
                      tooltip: 'Send message',
                      type: 'email',
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text(
                              'Pretend that this opened your SMS application.'),
                        ));
                      },
                      lines: <String>[
                        'Email',
                        email == null ? 'n/a' : email,
                      ],
                    ),
                    _ContactItem(
                      icon: Icons.message,
                      tooltip: 'Send message',
                      type: 'bio',
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('Bio has been updated!'),
                        ));
                      },
                      lines: <String>[
                        'Bio',
                        bio == null ? "n/a" : bio,
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Manage Product'),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UserProductPage.routeName);
                        },
                      ),
                      Divider(),

                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Profile'),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UserProductPage.routeName);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.chat),
                        title: Text('Chat with fashion expert'),
                        onTap: () {
                          Navigator.of(context).pushNamed(ChatPage.routeName);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
                        onTap: () async {
                          //if you forget to close the modal, it will end with this bug.
                          //This _ModalScope<dynamic> widget cannot be marked as needing to build because the framework is locked.
                          // Navigator.of(context).pop();
                          //always go to login page
                          Navigator.of(context).pushReplacementNamed('/');
                          await Provider.of<Auth>(context, listen: false)
                              .logout();
                        },
                      ),
                      // _storedImage != null
                      //     ? Image.file(
                      //         _storedImage,
                      //         fit: BoxFit.cover,
                      //         width: double.infinity,
                      //       )
                      //     : Text('No image taken'),
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
