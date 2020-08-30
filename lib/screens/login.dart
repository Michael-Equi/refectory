import 'package:flutter/material.dart';
import 'package:refectory/services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final Widget _logo = SvgPicture.asset("assets/images/refectory-logo.svg");
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  width: 300,
                  height: 200,
                  child: Image.asset(
                    "assets/images/refectory_signature.png",
                  ),
                ),
              ),
              Container(
                child: Image.asset("assets/images/plate_and_utencils.png"),
                padding: EdgeInsets.only(bottom: 50),
                width: 400,
                height: 300,
              ),
              Spacer(),
              LoginButton(
                text: 'Sign in with Google',
                icon: FontAwesomeIcons.google,
                color: Colors.black,
                textColor: Colors.white,
                loginMethod: auth.googleSignIn,
              ),
              FutureBuilder<Object>(
                future: auth.appleSignInAvailable,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return Container(
                      height: 70,
                      width: 400,
                      padding: EdgeInsets.only(bottom: 20),
                      child: AppleSignInButton(
                        style: ButtonStyle.black,
                        cornerRadius: 8,
                        onPressed: () async {
                          FirebaseUser user = await auth.appleSignIn();
                          if (user != null) {
                            Navigator.pushReplacementNamed(
                                context, '/cafeterias');
                          }
                        },
                      ),
                    );
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                },
              ),
            ]),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key,
      this.color,
      this.icon,
      this.text,
      this.loginMethod,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 70,
      padding: EdgeInsets.only(bottom: 20),
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: this.color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/cafeterias');
          }
        },
        icon: Icon(
          this.icon,
          color: this.textColor,
          size: 15,
        ),
        label: Text(
          "$text",
          style: TextStyle(color: this.textColor, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
