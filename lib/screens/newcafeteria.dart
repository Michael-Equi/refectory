import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refectory/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class NewCafeteriaDialog extends StatefulWidget {
  NewCafeteriaDialog({Key key}) : super(key: key);

  @override
  _NewCafeteriaDialogState createState() => _NewCafeteriaDialogState();
}

class _NewCafeteriaDialogState extends State<NewCafeteriaDialog> {
  final _formKey = GlobalKey<FormState>();
  String name, _uploadedFileURL;
  File _image;
  final String _defaultUrl =
      'https://firebasestorage.googleapis.com/v0/b/refectory-76cf7.appspot.com/o/cafeterias%2Fplate_and_utencils.png?alt=media&token=d4c013df-f9da-4f0d-b87f-3e29471587e3';
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  String _createCafeteria(String name, ImageProvider image, String ownerId) {
    var uuid = Uuid();
    String uid = uuid.v1().toString();
    var doc = Document<Cafeteria>(path: '/cafeterias/${uid}');

    if (_image != null) {
      Future<String> url = _uploadFile(uid);
      url.then(
        (url) => doc.upsert(
          {'iconUrl': url, 'uid': uid, 'name': name, 'ownerId': ownerId},
        ),
      );
    } else {
      doc.upsert(
        {'iconUrl': _defaultUrl, 'uid': uid, 'name': name, 'ownerId': ownerId},
      );
      print('New cafeteria created');
    }

    return uid;
  }

  Future<String> _uploadFile(String uuid) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('cafeterias/${uuid}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    return await storageReference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text('Create a new cafeteria'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter the name of the cafeteria'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                } else if (!value.contains(RegExp(r'^[a-zA-Z0-9 ]+$'))) {
                  return 'Only letters and numbers';
                }
                name = value;
                return null;
              },
            ),
            Row(children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                onPressed: _getImage,
                child: Text('Attach Image'),
              ),
              Spacer(),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                      image: _image == null
                          ? AssetImage('assets/images/plate_and_utencils.png')
                          : FileImage(_image),
                      fit: BoxFit.cover),
                ),
              ),
            ]),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  String uuid = _createCafeteria(
                      name = name,
                      _image == null
                          ? AssetImage('assets/images/plate_and_utencils.png')
                          : FileImage(_image),
                      user.uid);
                  Firestore.instance
                      .collection('users')
                      .document(user.uid)
                      .updateData({
                    'cafeterias': FieldValue.arrayUnion([uuid])
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
