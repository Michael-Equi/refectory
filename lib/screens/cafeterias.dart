import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:refectory/screens/screens.dart';
import 'package:refectory/services/services.dart';
import 'package:refectory/shared/shared.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
        // onPressed: () => showDialog(
        //   context: context,
        //   builder: (BuildContext context) => NewCafeteriaDialog(),
        // ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRViewExample())),
        tooltip: 'Add cafeteria',
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewCafeteriaDialog extends StatefulWidget {
  NewCafeteriaDialog({Key key}) : super(key: key);

  @override
  _NewCafeteriaDialogState createState() => _NewCafeteriaDialogState();
}

class _NewCafeteriaDialogState extends State<NewCafeteriaDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _joinCafeteria(String name) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text('Join a new cafeteria'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter the id of the cafeteria'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                } else if (value.contains(' ')) {
                  return 'No spaces please ;)';
                } else if (!value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                  return 'Only letters and numbers';
                }
                return null;
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class CafeteriaList extends StatelessWidget {
  const CafeteriaList({Key key, this.snapshot}) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData) return const CircularProgressIndicator();
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
                    image: NetworkImage(snapshot.data.iconUrl),
                    uid: snapshot.data.uid,
                    description: snapshot.data.name,
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
  const CafeteriaTab({Key key, this.image, this.uid, this.description})
      : super(key: key);
  final NetworkImage image;
  final String uid;
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
        onPressed: () => Navigator.pushNamed(context, '/meals',
            arguments: MealsArguments(this.uid, "Message")),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  QRViewExample({Key key}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RefectoryAppBar(pageName: "qr scanner"),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan result: $qrText'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
