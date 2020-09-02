import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refectory/services/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'chat.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class MealsPanel extends StatefulWidget {
  MealsPanel({Key key, this.cafeteriaId}) : super(key: key);
  String cafeteriaId;

  @override
  _MealsPanelState createState() => _MealsPanelState();
}

class _MealsPanelState extends State<MealsPanel> {
  int _index = 0;
  double _rating = 0;
  String dropdownValue = 'Breakfast';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    final selectedDate = Provider.of<ValueNotifier<DateTime>>(context);

    var center = Center(
      child: StreamBuilder(
          stream: Document<Cafeteria>(path: 'cafeterias/${widget.cafeteriaId}')
              .streamData(),
          builder: (context, snapshot) {
            print(snapshot.data.uid);
            if (!snapshot.hasData) return const CircularProgressIndicator();
            bool isOwner = user.uid == snapshot.data.ownerId;
            return StreamBuilder(
              stream: Firestore.instance
                  .collection('cafeterias')
                  .document(snapshot.data.uid)
                  .collection('mealrefs')
                  .getDocuments()
                  .asStream(),
              builder: (context, snapshot) => PageView.builder(
                itemCount: 10 + (isOwner ? 1 : 0),
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  print(snapshot.data.size);
                  if (i == 0 && isOwner) {
                    return InkWell(
                      onTap: () => showDialog(
                          context: context,
                          child: CreatMealForm(formKey: _formKey)),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.add_circle,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: MealCard(),
                  );
                },
              ),
            );
          }),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.grey),
          underline: Container(
            color: Colors.grey,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Breakfast', 'Brunch', 'Lunch', 'Dinner']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 0, bottom: 30),
            child: center,
          ),
        ),
      ],
    );
  }
}

class CreatMealForm extends StatefulWidget {
  const CreatMealForm({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  _CreatMealFormState createState() => _CreatMealFormState();
}

class _CreatMealFormState extends State<CreatMealForm> {
  File _image;
  final picker = ImagePicker();
  bool _isVegan = false;

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
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
          height: 200,
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
                  if (widget._formKey.currentState.validate()) {}
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

class MealCard extends StatelessWidget {
  const MealCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/eggs-breakfast-avocado-1296x728-header.jpg?w=1155&h=1528",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.leaf,
                  color: Colors.green,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {
                        print("Hello");
                      },
                      starCount: 5,
                      rating: 2,
                      size: 25.0,
                      isReadOnly: false,
                      color: Colors.green,
                      borderColor: Colors.green,
                      spacing: 0.0),
                ),
                Container(
                  width: 60,
                  child: FlatButton(
                    child: Icon(FontAwesomeIcons.archive),
                    onPressed: () => print("Hello"),
                  ),
                ),
              ],
            ),
            MealChat()
          ]),
    );
  }
}
