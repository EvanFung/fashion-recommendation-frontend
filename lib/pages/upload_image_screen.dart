import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/Tweet.dart';
import 'dart:io';
import '../utils/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class UploadImageScreen extends StatefulWidget {
  static const routeName = '/upload-image';

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File file;
  //Strings required to save address
  Address address;
  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool posting = false;

  @override
  void initState() {
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location

    // TODO: implement initState
    super.initState();
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await LocationService().getUserLocation();
    setState(() {
      address = first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white70,
              title: const Text(
                'Select a photo to post a new twitte',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            body: Center(
              child: IconButton(
                  icon: Icon(Icons.file_upload),
                  onPressed: () {
                    _selectImage(context);
                  }),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title: const Text(
                'Post to',
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    if (posting) {
                      print('posting....');
                    } else {
                      postImage();
                    }
                  },
                  child: posting
                      ? Text(
                          'Posting...',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )
                      : Text(
                          "Post",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                )
              ],
            ),
            body: ListView(
              children: <Widget>[
                PostForm(
                  imageFile: file,
                  descriptionController: descriptionController,
                  locationController: locationController,
                ),
                Divider(),
                (address == null)
                    ? Container()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        child: Row(
                          children: <Widget>[
                            buildLocationButton(address.featureName),
                            buildLocationButton(address.subLocality),
                            buildLocationButton(address.locality),
                            buildLocationButton(address.subAdminArea),
                            buildLocationButton(address.adminArea),
                            buildLocationButton(address.countryName),
                          ],
                        ),
                      ),
                (address == null) ? Container() : Divider(),
              ],
            ),
          );
  }

  Future<Null> _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File imageFile = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = imageFile;
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() async {
    setState(() {
      posting = true;
    });
    Map<String, dynamic> fileJson = await uploadImage(file);
    var imgae = fileJson['objectId'];
    var createBy = Provider.of<Tweets>(context).userID;
    var likes = 0;
    var location = locationController.text;
    var description = descriptionController.text;
    await Provider.of<Tweets>(context).addTweet(
      image: imgae,
      createBy: createBy,
      likes: likes,
      location: location,
      description: description,
    );
    setState(() {
      posting = false;
    });
    Navigator.of(context).pop();
  }

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = await path.basename(imageFile.path);
    final saveImage = await imageFile.copy('${appDir.path}/$fileName');
    Map<String, dynamic> fileJson =
        await Provider.of<Tweets>(context).uploadImage(saveImage, fileName);
    return fileJson;
  }
}

class PostForm extends StatelessWidget {
  var imageFile;
  final bool loading = false;

  TextEditingController descriptionController;
  TextEditingController locationController;

  PostForm(
      {this.imageFile, this.descriptionController, this.locationController});

  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(),
            Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              width: 45.0,
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: FileImage(imageFile),
                  )),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}
