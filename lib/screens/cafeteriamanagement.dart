import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refectory/services/models.dart';
import 'package:refectory/shared/shared.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CafeteriaManagementPage extends StatefulWidget {
  const CafeteriaManagementPage({Key key}) : super(key: key);

  @override
  _CafeteriaManagementPageState createState() =>
      _CafeteriaManagementPageState();
}

class _CafeteriaManagementPageState extends State<CafeteriaManagementPage> {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = "Breakfast";

  Future _getUserMealPairings(Cafeteria cafeteria, FirebaseUser user) async {
    Map<String, List<String>> savedUserMealMappings = {};
    var mealrefs = await Firestore.instance
        .collection('cafeterias')
        .document(cafeteria.uid)
        .collection('mealrefs')
        .where("date",
            isEqualTo: DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day))
        .getDocuments();
    if (mealrefs != null && mealrefs.documents.isNotEmpty) {
      var mealArr = mealrefs.documents[0].data[dropdownValue];
      if (mealArr != null && mealArr.isNotEmpty) {
        for (int i = 0; i < mealArr.length; i++) {
          var meals = await Firestore.instance
              .collection('cafeterias')
              .document(cafeteria.uid)
              .collection('meals')
              .document(mealArr[i])
              .get();
          if (meals.data['savers'] != null && meals.data['savers'].isNotEmpty) {
            for (int n = 0; n < meals.data['savers'].length; n++) {
              var usersProf = await Firestore.instance
                  .collection('users')
                  .document(meals.data['savers'][n])
                  .get();
              if (savedUserMealMappings.containsKey(usersProf.data['name'])) {
                print("Hello");
                savedUserMealMappings[usersProf.data['name']]
                    .add(meals.data['name']);
              } else {
                savedUserMealMappings.addAll({
                  usersProf.data['name']: [meals.data['name']]
                });
              }
            }
          }
        }
      }
    }
    return savedUserMealMappings;
  }

  @override
  Widget build(BuildContext context) {
    final Cafeteria cafeteria = ModalRoute.of(context).settings.arguments;
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: RefectoryAppBar(
        pageName: "management",
      ),
      body: Column(children: [
        FlatButton(
          onPressed: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime.now().subtract(Duration(days: 365)),
                maxTime: DateTime.now(),
                currentTime: selectedDate,
                theme: DatePickerTheme(
                    headerColor: Colors.grey[500],
                    backgroundColor: Colors.grey[300],
                    itemStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                onChanged: (date) {
              setState(() {
                selectedDate = date;
              });
            });
          },
          child: Text(
              "Selected date: ${selectedDate.month}-${selectedDate.day}-${selectedDate.year}"),
        ),
        Center(
          child: DropdownButton<String>(
            value: dropdownValue,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
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
                child: Text("Meal: ${value}"),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _getUserMealPairings(cafeteria, user),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: Text("Loading..."));
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 10),
                              child:
                                  Text(snapshot.data.keys.toList()[0] + " : ")),
                          Flexible(
                            child: Text(
                              (snapshot.data[snapshot.data.keys.toList()[0]])
                                  .toString(),
                            ),
                          )
                        ],
                      ));
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
            },
          ),
        )
      ]),
    );
  }
}
