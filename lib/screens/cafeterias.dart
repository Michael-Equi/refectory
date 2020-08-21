import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:refectory/services/services.dart';
import 'package:refectory/shared/shared.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  final String title = "Hello";

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user == null)
      return Scaffold(
        appBar: RefectoryAppBar(
          pageName: "Cafeteria",
        ),
      );
    return Scaffold(
      appBar: RefectoryAppBar(
        pageName: "cafeterias",
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: StreamBuilder(
            stream: Document<User>(path: "users/${user.uid}").streamData(),
            builder: (context, snapshot) => CafeteriaList(
              snapshot: snapshot,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CafeteriaList extends StatelessWidget {
  const CafeteriaList({Key key, this.snapshot}) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData) return const Text("Loading");
    return ListView.separated(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            StreamBuilder(
                stream: Document<Cafeteria>(
                        path: 'cafeterias/${snapshot.data.cafeterias[index]}')
                    .streamData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text("Loading");
                  return CafeteriaTab(
                    description: snapshot.data.name,
                    image: NetworkImage(snapshot.data.iconUrl),
                  );
                }),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

class CafeteriaTab extends StatelessWidget {
  const CafeteriaTab({Key key, this.image, this.description}) : super(key: key);
  final NetworkImage image;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              image: DecorationImage(image: image, fit: BoxFit.fill),
            ),
          ),
          Container(
            child:
                Text(description, style: Theme.of(context).textTheme.headline2),
            padding: EdgeInsets.only(left: 30),
          ),
        ]),
        onPressed: () => Navigator.pushNamed(context, '/meals'),
      ),
    );
  }
}
