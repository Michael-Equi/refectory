import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refectory/services/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Widget _logo = SvgPicture.asset("assets/images/refectory-logo.svg");
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                text: 'Continue as Guest', loginMethod: _auth.anonLogin),
          ]),
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
            Navigator.pushReplacementNamed(context, '/topics');
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
