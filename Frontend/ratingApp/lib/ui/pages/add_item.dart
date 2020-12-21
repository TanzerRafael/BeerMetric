import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ratingApp/blocs/mltext_bloc.dart';
import 'package:ratingApp/resources/repos/repository.dart';
import 'package:ratingApp/ui/pages/camera/camera_screen.dart';
import 'package:ratingApp/ui/pages/choose_name.dart';

import '../../locator.dart';
import '../../navigation_service.dart';
import '../../route_paths.dart' as routes;

import '../../resources/mltext_provider.dart';

//2
class AddItem extends StatefulWidget {
  final String title = 'Sign In';

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _overallRating = 0;
  bool _success;
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 32,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      _image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: 30.0, top: 20.0, right: 30.0, bottom: 20.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                )),
            Container(
              child: Center(
                child: _buildRatingBar()
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _add();
                  }
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(){
    return RatingBar.builder(
        initialRating: 1,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 6,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.orangeAccent,
        ),
        onRatingUpdate: (rating){
          this._overallRating = rating;
        }
    );
  }

  void _add() async {
    final bytes = _image.readAsBytesSync();
    String img64 = base64Encode(bytes);
    print('NEW ENTRY');
    print(img64);
    print(_nameController.text);
    print(_overallRating);
    print(_auth.currentUser.uid);
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createNewEntry');
    callable.call(<String,dynamic>{
      'image': img64,
      'name': _nameController.text,
      'overAllRating': _overallRating,
      'userIdRate': [_auth.currentUser.uid]
      /*'image': 'TestTest',
      'name': 'Test1234567890',
      'overAllRating': 4,
      'userIdRate': ['user1']*/
    });
    locator<NavigationService>().goBack();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  _imgFromCamera() async {

    final cam = (await availableCameras()).first;

    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
    /*final imgPath = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(cam: cam)));

    if(imgPath != ""){
      setState(() {
        _image = File(imgPath);
      });
    }*/

    await Navigator.push(context, MaterialPageRoute(builder: (c) => ChooseName(img: _image)));

    List<String> words = mlTextBloc.getChosenWords();
    String chosenWords = "";
    for(var word in words){
      chosenWords += word+" ";
    }

    _nameController.text = chosenWords;

    print("MlText: ChosenWords $chosenWords");
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    await Navigator.push(context, MaterialPageRoute(builder: (c) => ChooseName(img: _image)));

    List<String> words = mlTextBloc.getChosenWords();
    String chosenWords = "";
    for(var word in words){
      chosenWords += word+" ";
    }

    _nameController.text = chosenWords;

    print("MlText: ChosenWords $chosenWords");
  }
  // Gives the user the option to pick between inserting an image from camera or gallery
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _imgFromCamera();
                      //Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}