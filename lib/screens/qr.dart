import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:refectory/shared/shared.dart';
import 'package:refectory/screens/screens.dart';
import 'package:provider/provider.dart';

class QRViewExample extends StatefulWidget {
  QRViewExample({Key key}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _formKey = GlobalKey<FormState>();
  bool scanned = false;
  FirebaseUser user;
  BuildContext context;

  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: RefectoryAppBar(pageName: "Scan QR Code"),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => NewCafeteriaDialog(),
                ),
                child: Text("Create new"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        Firestore.instance.collection('users').document(user.uid).updateData({
          "cafeterias": FieldValue.arrayUnion([scanData])
        });
        Navigator.pop(context);
        scanned = true;
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
