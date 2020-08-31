import 'package:flutter/material.dart';
import 'package:refectory/shared/shared.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'screens.dart';

class MealsArguments {
  final String cafeteriaUid;
  final String message;

  MealsArguments(this.cafeteriaUid, this.message);
}

class Meals extends StatelessWidget {
  const Meals({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MealsArguments args = ModalRoute.of(context).settings.arguments;
    print(args.cafeteriaUid);
    return Scaffold(
      appBar: RefectoryAppBar(
        pageName: "meals",
      ),
      body: SlidingUpPanel(
        panel: MealsPanel(cafeteriaId: args.cafeteriaUid),
        body: MealsCalendar(cafeteriaId: args.cafeteriaUid),
        minHeight: 100,
      ),
    );
  }
}
