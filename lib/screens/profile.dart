import 'package:flutter/material.dart';
import 'package:refectory/services/auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          color: Colors.grey,
          onPressed: () {
            auth.signOut();
            Navigator.popAndPushNamed(context, '/');
          },
          child: Container(width: 50, height: 50, child: Text("Sign out")),
        ),
      ),
    );
  }
}
