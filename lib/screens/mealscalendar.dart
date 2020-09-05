import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class MealsCalendar extends StatefulWidget {
  MealsCalendar({Key key, this.cafeteriaId}) : super(key: key);
  String cafeteriaId;
  @override
  _MealsCalendarState createState() => _MealsCalendarState();
}

class _MealsCalendarState extends State<MealsCalendar> {
  Map<DateTime, List> _events;
  List _selectedEvents;
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
    final _selectedDay = DateTime.now();
    // _events = {
    //   _selectedDay.subtract(Duration(days: 30)): [
    //     'Event A0',
    //     'Event B0',
    //     'Event C0'
    //   ],
    // };

    // _selectedEvents = _events[_selectedDay] ?? [];

    return _buildTableCalendar();
  }

  void _onDaySelected(DateTime day, List events) {
    final selelctedDate =
        Provider.of<ValueNotifier<DateTime>>(context, listen: false);

    print('CALLBACK: _onDaySelected');
    setState(() {
      selelctedDate.value = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.grey[500],
        todayColor: Colors.grey[200],
        markersColor: Colors.grey[500],
        outsideDaysVisible: false,
        weekendStyle: TextStyle(color: Colors.grey),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.grey[500]),
      ),
    );
  }
}
