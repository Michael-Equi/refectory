import 'package:flutter/material.dart';
import 'package:refectory/shared/shared.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'screens.dart';
import 'package:provider/provider.dart';

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ValueNotifier<DateTime>>(
              create: (context) => ValueNotifier<DateTime>(DateTime.now()),
            ),
          ],
          child: SlidingUpPanel(
            panel: MealsPanel(cafeteriaId: args.cafeteriaUid),
            body: MealsCalendar(cafeteriaId: args.cafeteriaUid),
            minHeight: 100,
          ),
        ),
      ),
    );
  }
}
