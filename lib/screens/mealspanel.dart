import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refectory/services/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'chat.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens.dart';

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
  DateTime lastDate;
  var pageController = PageController(viewportFraction: 0.7);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    final selectedDate = Provider.of<ValueNotifier<DateTime>>(context);

    if (lastDate != selectedDate.value && _index != 0) {
      _index = 0;
      pageController.animateTo(0,
          duration: Duration(milliseconds: 1), curve: Curves.linear);
    }
    lastDate = selectedDate.value;

    var center = Center(
      child: StreamBuilder(
          stream: Document<Cafeteria>(path: 'cafeterias/${widget.cafeteriaId}')
              .streamData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            bool isOwner = user.uid == snapshot.data.ownerId;
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('cafeterias')
                    .document(snapshot.data.uid)
                    .collection('mealrefs')
                    .where('date', isEqualTo: selectedDate.value)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return PageView.builder(
                    itemCount: snapshot.data.documents.length > 0
                        ? (snapshot.data.documents[0][dropdownValue]?.length ??
                                0) +
                            (isOwner ? 1 : 0)
                        : (isOwner ? 1 : 0),
                    controller: pageController,
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (_, i) {
                      if (i == 0 && isOwner) {
                        return InkWell(
                          onTap: () => showDialog(
                            context: context,
                            child: CreateMealForm(
                              formKey: _formKey,
                              cafeteriaUid: widget.cafeteriaId,
                              selectedMealTime: dropdownValue,
                              selectedDate: selectedDate.value,
                            ),
                          ),
                          child: Transform.scale(
                            scale: i == _index ? 1 : 0.9,
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
                          ),
                        );
                      } else {
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: MealCard(
                            mealId: snapshot.data.documents[0][dropdownValue]
                                [i - (isOwner ? 1 : 0)],
                            cafeteriaId: widget.cafeteriaId,
                          ),
                        );
                      }
                    },
                  );
                });
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
              _index = 0;
              pageController.animateToPage(_index,
                  duration: Duration(milliseconds: 1), curve: Curves.linear);
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

class MealCard extends StatelessWidget {
  final String mealId;
  final String cafeteriaId;
  const MealCard({
    Key key,
    this.mealId,
    this.cafeteriaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Document<MealDoc>(path: 'cafeterias/${cafeteriaId}/meals/${mealId}')
              .streamData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  child: Image.network(
                    snapshot.data.iconUrl,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(snapshot.data.name)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.leaf,
                      color:
                          snapshot.data.isVegan ? Colors.green : Colors.white,
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
                MealChat(
                  cafeteriaId: cafeteriaId,
                  mealId: mealId,
                )
              ]),
        );
      },
    );
  }
}
