import 'package:flutter/material.dart';
import 'package:refectory/services/services.dart';
import 'package:refectory/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';

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
        body: MealsCalendar());
  }
}

class MealsCalendar extends StatefulWidget {
  MealsCalendar({Key key}) : super(key: key);
  @override
  _MealsCalendarState createState() => _MealsCalendarState();
}

class _MealsCalendarState extends State<MealsCalendar> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: _calendarController,
    );
  }
}
