import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refectory/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'chat.dart';

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
        panel: MealsPanel(),
        minHeight: 50,
        body: MealsCalendar(),
      ),
    );
  }
}

class MealsCalendar extends StatefulWidget {
  MealsCalendar({Key key}) : super(key: key);
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
    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    return _buildTableCalendar();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
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
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      // onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }
}

class MealsPanel extends StatefulWidget {
  const MealsPanel({Key key}) : super(key: key);

  @override
  _MealsPanelState createState() => _MealsPanelState();
}

class _MealsPanelState extends State<MealsPanel> {
  int _index = 0;
  double _rating = 0;

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    var center = Center(
      child: PageView.builder(
        itemCount: 10,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/eggs-breakfast-avocado-1296x728-header.jpg?w=1155&h=1528",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.leaf,
                          color: Colors.green,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 20),
                          child: SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                print("Hello");
                              },
                              starCount: 5,
                              rating: 2,
                              size: 25.0,
                              isReadOnly: false,
                              color: Colors.green,
                              borderColor: Colors.green,
                              spacing: 0.0),
                        ),
                        Container(
                          width: 60,
                          child: FlatButton(
                            child: Icon(FontAwesomeIcons.archive),
                            onPressed: () => print("Hello"),
                          ),
                        ),
                      ],
                    ),
                    MealChat()
                  ]),
            ),
          );
        },
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 0, bottom: 30),
            child: center,
          ),
        ),
      ],
    );
  }
}
