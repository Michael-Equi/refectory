import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:refectory/shared/shared.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  final String title = "Hello";

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: RefectoryAppBar(
        pageName: "cafeterias",
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView.separated(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  cafeteria(
                    description: "Bowles",
                    image: NetworkImage(
                        "https://media-exp1.licdn.com/dms/image/C560BAQEShiy5M3rf5g/company-logo_200_200/0?e=2159024400&v=beta&t=e8nH_Weve1cbLmK7cN4KBBpkFxjKOcp3eF3OdXICNQw"),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
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
  const cafeteria({Key key, this.image, this.description}) : super(key: key);
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
