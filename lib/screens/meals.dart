import 'package:flutter/material.dart';
import 'package:refectory/shared/shared.dart';

class Meals extends StatelessWidget {
  const Meals({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RefectoryAppBar(
        pageName: "meals",
      ),
    );
  }
}
