import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refectory/services/models.dart';
import 'package:refectory/shared/shared.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'screens.dart';
import 'package:provider/provider.dart';

class MealsArguments {
  final Cafeteria cafeteria;
  MealsArguments(this.cafeteria);
}

class Meals extends StatelessWidget {
  const Meals({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MealsArguments args = ModalRoute.of(context).settings.arguments;
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("meals"),
        actions: <Widget>[
          args.cafeteria.ownerId == user.uid
              ? IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, '/management',
                      arguments: args.cafeteria),
                )
              : Container(),
          IconButton(
            icon: Icon(FontAwesomeIcons.userCircle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
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
            panel: MealsPanel(cafeteriaId: args.cafeteria.uid),
            body: MealsCalendar(cafeteriaId: args.cafeteria.uid),
            minHeight: 100,
          ),
        ),
      ),
    );
  }
}
