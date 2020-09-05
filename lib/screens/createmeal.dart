import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:refectory/services/services.dart';
import 'package:provider/provider.dart';

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({
    Key key,
    this.cafeteriaUid,
    this.selectedMealTime,
    this.selectedDate,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final cafeteriaUid;
  final selectedMealTime;
  final selectedDate;

  @override
  _CreateMealFormState createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  File _image;
  bool _isVegan = false;
  String _name;
  final picker = ImagePicker();

  final String _defaultUrl =
      'https://firebasestorage.googleapis.com/v0/b/refectory-76cf7.appspot.com/o/cafeterias%2Fplate_and_utencils.png?alt=media&token=d4c013df-f9da-4f0d-b87f-3e29471587e3';

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<String> _uploadFile(String uuid) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('meals/${uuid}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    return await storageReference.getDownloadURL();
  }

  String createMeal(String cafeteriaId, ImageProvider image) {
    var uuid = Uuid();
    String uid = uuid.v1().toString();
    var doc =
        Document<MealDoc>(path: '/cafeterias/${cafeteriaId}/meals/${uid}');

    if (_image != null) {
      Future<String> url = _uploadFile(uid);
      url.then(
        (url) => doc.upsert(
          {
            'iconUrl': url,
            'uid': uid,
            'name': _name,
            'isVegan': _isVegan,
            'meal': widget.selectedMealTime
          },
        ),
      );
    } else {
      doc.upsert(
        {
          'iconUrl': _defaultUrl,
          'uid': uid,
          'name': _name,
          'isVegan': _isVegan,
          'meal': widget.selectedMealTime
        },
      );
      print('New meal created');
    }

    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text("Create New Meal Item"),
        content: Container(
          height: 240,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the name of the meal'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!value.contains(RegExp(r'^[a-zA-Z0-9 ]+$'))) {
                    return 'Only letters and numbers';
                  }
                  _name = value;
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
                  height: 70,
                  width: 70,
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
              Row(children: [
                Checkbox(
                    value: _isVegan,
                    activeColor: Colors.green,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isVegan = newValue;
                      });
                    }),
                Text('Vegan')
              ]),
              Spacer(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  if (widget._formKey.currentState.validate()) {
                    String uid = createMeal(
                      widget.cafeteriaUid,
                      _image == null
                          ? AssetImage('assets/images/plate_and_utencils.png')
                          : FileImage(_image),
                    );
                    Firestore.instance
                        .collection('cafeterias')
                        .document(widget.cafeteriaUid)
                        .collection("mealrefs")
                        .where('date', isEqualTo: widget.selectedDate)
                        .getDocuments()
                        .then(
                      (value) {
                        if (value.documents.length > 0) {
                          //append to list
                          Firestore.instance
                              .collection('cafeterias')
                              .document(widget.cafeteriaUid)
                              .collection('mealrefs')
                              .document(value.documents[0]['uid'])
                              .updateData({
                            widget.selectedMealTime:
                                FieldValue.arrayUnion([uid])
                          });
                        } else {
                          // create a new refs document for this date
                          var uuid = Uuid();
                          String docid = uuid.v1().toString();
                          Firestore.instance
                              .collection('cafeterias')
                              .document(widget.cafeteriaUid)
                              .collection('mealrefs')
                              .document(docid)
                              .setData({
                            "date": widget.selectedDate,
                            "uid": docid,
                            widget.selectedMealTime: [uid]
                          });
                        }
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
