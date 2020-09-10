import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refectory/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${user?.displayName ?? "Guest"}",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (user?.photoUrl != null)
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(user.photoUrl), fit: BoxFit.fill),
                  ),
                ),
              if (user?.photoUrl == null)
                Expanded(
                    child: Icon(
                  FontAwesomeIcons.userCircle,
                  size: 100,
                )),
              Text(user?.email ?? ''),
              Spacer(),
              FlatButton(
                color: null,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                  auth.signOut();
                },
                child: Container(
                  child: Text(
                    "Sign out",
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  alignment: Alignment.center,
                ),
              ),
            ]),
      ),
    );
  }
}
