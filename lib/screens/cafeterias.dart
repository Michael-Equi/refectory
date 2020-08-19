import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  final String title = "Hello";

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cafeteria Page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView(
            children: <Widget>[cafeteria(), cafeteria()],
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

class cafeteria extends StatelessWidget {
  const cafeteria({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: FlatButton(
        child: Text("Bowles dinning hall",
            style: Theme.of(context).textTheme.headline4),
        color: Colors.grey,
        onPressed: () => null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
