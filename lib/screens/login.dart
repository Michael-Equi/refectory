import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refectory/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Widget _logo = SvgPicture.asset("assets/images/refectory-logo.svg");
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(2),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: _logo,
                width: 300,
                height: 300,
                padding: EdgeInsets.only(bottom: 50),
              ),
              LoginButton(
                text: 'LOGIN WITH GOOGLE',
                icon: FontAwesomeIcons.google,
                color: Colors.black45,
                loginMethod: auth.googleSignIn,
              ),
              FutureBuilder<Object>(
                future: auth.appleSignInAvailable,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return AppleSignInButton(
                      style: ButtonStyle.black,
                      onPressed: () async {
                        FirebaseUser user = await auth.appleSignIn();
                        if (user != null) {
                          Navigator.pushReplacementNamed(
                              context, '/cafeterias');
                        }
                      },
                    );
                  }
                },
              ),
              LoginButton(
                  text: 'Continue as Guest', loginMethod: auth.anonLogin),
            ]),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.color, this.icon, this.text, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        color: this.color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/cafeterias');
          }
        },
        icon: Icon(this.icon),
        label: Expanded(
          child: Text(
            "$text",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
