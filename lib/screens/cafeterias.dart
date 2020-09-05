import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:refectory/screens/screens.dart';
import 'package:refectory/services/services.dart';
import 'package:refectory/shared/shared.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRViewExample())),
        tooltip: 'Add cafeteria',
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
    if (!snapshot.hasData)
      return Center(child: Text("Press the '+' button to add a cafeteria"));
    return ListView.separated(
      itemCount: snapshot.data.cafeterias.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            StreamBuilder(
                stream: Document<Cafeteria>(
                        path: 'cafeterias/${snapshot.data.cafeterias[index]}')
                    .streamData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return CafeteriaTab(
                    cafeteria: snapshot.data,
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
  const CafeteriaTab({Key key, this.cafeteria}) : super(key: key);
  final Cafeteria cafeteria;

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
              image: DecorationImage(
                  image: NetworkImage(this.cafeteria.iconUrl),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            child: Text(this.cafeteria.name,
                style: Theme.of(context).textTheme.headline2),
            padding: EdgeInsets.only(left: 30),
          ),
          Spacer(),
          Container(
            height: 50,
            width: 50,
            child: FlatButton(
              child: Icon(
                FontAwesomeIcons.qrcode,
                size: 20,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Container(
                    height: 250,
                    width: 400,
                    child: QrImage(
                      data: this.cafeteria.uid,
                      version: QrVersions.auto,
                      size: 400.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
        onPressed: () => Navigator.pushNamed(context, '/meals',
            arguments: MealsArguments(
              this.cafeteria,
            )),
      ),
    );
  }
}
