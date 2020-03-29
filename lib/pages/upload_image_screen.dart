import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  static const routeName = '/upload-image';

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  var file;
  TextEditingController descriptionController = new TextEditingController();
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
                  icon: Icon(Icons.file_upload), onPressed: _selectImage),
            ))
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
                    onPressed: postImage,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
              ],
            ),
            body: PostForm(
              imageFile: file,
              descriptionController: descriptionController,
            ),
          );
  }

  Future<Null> _selectImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    Future<String> upload = uploadImage(file).then((String data) {
      postToFireStore(mediaUrl: data, description: descriptionController.text);
    });
  }
}

class PostForm extends StatelessWidget {
  var imageFile;
  TextEditingController descriptionController;
  PostForm({this.imageFile, this.descriptionController});

  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Padding(padding: new EdgeInsets.only(top: 10.0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new CircleAvatar(
              child: new Text("d"),
            ),
            new Container(
              width: 250.0,
              child: new TextField(
                controller: descriptionController,
                decoration: new InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            new Container(
                height: 50.0,
                child: new Image.file(
                  imageFile,
                  fit: BoxFit.fitHeight,
                ))
          ],
        ),
        new Divider()
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  return 'url string';
}

void postToFireStore({String mediaUrl, String location, String description}) {}
