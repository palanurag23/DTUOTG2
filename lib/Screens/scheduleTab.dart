import 'package:DTUOTG/models/events.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart' as utl;
import '../models/lecture.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';

class ScheduleTab extends StatefulWidget {
  ScheduleTab({Key key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<utl.Event>> _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<utl.Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return utl.kEvents[day] ?? [];
  }

  bool initialized = false;

  List<Lecture> lectures = [];
  int weekDayIndex = 1;

  @override
  void didChangeDependencies() {
    if (!initialized) {
      weekDayIndex = DateTime.now().weekday > 5 ? 5 : DateTime.now().weekday;

      lectures =
          Provider.of<TimeTableData>(context, listen: false).get(weekDayIndex);

      setState(() {
        initialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Container(
            child: TableCalendar(
              eventLoader: (day) {
                //  return _getEventsForDay(day);
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  print(selectedDay.toString());
                  print(focusedDay.toString());
                  _selectedDay = selectedDay;
                  lectures = Provider.of<TimeTableData>(context, listen: false)
                      .get(selectedDay.weekday);
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              firstDay: DateTime.now().subtract(Duration(days: 10)),
              lastDay: DateTime.now().add(Duration(days: 10)),
              focusedDay: _focusedDay,
            ),
          ),
          Text('${_selectedDay.toString()}'),
          if (!initialized) CircularProgressIndicator(),
          if (initialized)
            if (lectures.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'empty',
                  style: TextStyle(fontSize: 50),
                ),
              ),
          if (lectures.isNotEmpty)
            Expanded(
              child: new ListView.builder(
                itemBuilder: (context, index) {
                  int hour = lectures[index].time.hour;
                  int length = lectures[index].length;
                  bool happeningNow = false;

                  if (lectures[index].time.hour == TimeOfDay.now().hour) {
                    happeningNow = true;
                  } else {
                    if ((lectures[index].time.hour < TimeOfDay.now().hour) &&
                        ((lectures[index].time.hour + lectures[index].length) >
                            TimeOfDay.now().hour)) {
                      happeningNow = true;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                        leading: happeningNow
                            ? Text(
                                'now',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )
                            : Icon(Icons.access_time_outlined),
                        subtitle: Text('$hour-${hour + length}'),
                        tileColor: lectures[index].free
                            ? Colors.red
                            : happeningNow
                                ? Colors.tealAccent[400]
                                : Colors.amberAccent[100],
                        title: lectures[index].free
                            ? Text(
                                'FREE',
                                style: TextStyle(color: Colors.yellow),
                              )
                            : Text(lectures[index].name),
                        trailing: Text(
                          '$length hour',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  );
                },
                itemCount: lectures.length,
              ),
            ),
          // Container(
          //     height: 300,
          //     padding: EdgeInsets.only(top: 70),
          //     child: SfCalendar(
          //       appointmentBuilder: (BuildContext context,
          //           CalendarAppointmentDetails calendarAppointmentDetails) {},
          //       firstDayOfWeek: 1,
          //       showCurrentTimeIndicator: true,
          //       maxDate: DateTime.now().add(Duration(days: 10)),
          //       minDate: DateTime.now().subtract(Duration(days: 10)),
          //       todayHighlightColor: Colors.amber[800],
          //       showNavigationArrow: true,
          //       initialDisplayDate: DateTime.now(),
          //       view: CalendarView.month,
          //       monthViewSettings: MonthViewSettings(numberOfWeeksInView: 1),
          //     )),
        ],
      ),
    );
  }
}
/*TableCalendar(eventLoader: ,
            onFormatChanged: (c) {},
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, daet, ev) {},
            ),
            onDaySelected: (newDay, x) {
              print('day');
              focusedDay = newDay;
            },
            calendarFormat: CalendarFormat.week,
            firstDay: DateTime.now().subtract(Duration(days: 10)),
            lastDay: DateTime.now().add(Duration(days: 10)),
            focusedDay: focusedDay,
//           ) */
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';

// class DynamicEvent extends StatefulWidget {
//   @override
//   _DynamicEventState createState() => _DynamicEventState();
// }

// class _DynamicEventState extends State<DynamicEvent> {
//   CalendarController _controller;
//   Map<DateTime, List<dynamic>> _events;
//   List<dynamic> _selectedEvents;
//   TextEditingController _eventController;
//   SharedPreferences prefs;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CalendarController();
//     _eventController = TextEditingController();
//     _events = {};
//     _selectedEvents = [];
//     prefsData();
//   }

//   prefsData() async {
//     prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _events = Map<DateTime, List<dynamic>>.from(
//           decodeMap(json.decode(prefs.getString("events") ?? "{}")));
//     });
//   }

//   Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
//     Map<String, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[key.toString()] = map[key];
//     });
//     return newMap;
//   }
//   Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
//     Map<DateTime, dynamic> newMap = {};
//     map.forEach((key, value) {
//       newMap[DateTime.parse(key)] = map[key];
//     });
//     return newMap;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.black,
//         title: Text('Flutter Dynamic Event Calendar'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TableCalendar(
//               events: _events,
//               initialCalendarFormat: CalendarFormat.week,
//               calendarStyle: CalendarStyle(
//                   canEventMarkersOverflow: true,
//                   todayColor: Colors.orange,
//                   selectedColor: Theme.of(context).primaryColor,
//                   todayStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white)),
//               headerStyle: HeaderStyle(
//                 centerHeaderTitle: true,
//                 formatButtonDecoration: BoxDecoration(
//                   color: Colors.orange,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 formatButtonTextStyle: TextStyle(color: Colors.white),
//                 formatButtonShowsNext: false,
//               ),
//               startingDayOfWeek: StartingDayOfWeek.monday,
//               onDaySelected: (date, events,holidays) {
//                 setState(() {
//                   _selectedEvents = events;
//                 });
//               },
//               builders: CalendarBuilders(
//                 selectedDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 todayDayBuilder: (context, date, events) => Container(
//                     margin: const EdgeInsets.all(4.0),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ),
//               calendarController: _controller,
//             ),
//             ..._selectedEvents.map((event) => Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: MediaQuery.of(context).size.height/20,
//                 width: MediaQuery.of(context).size.width/2,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey)
//                 ),
//                 child: Center(
//                     child: Text(event,
//                       style: TextStyle(color: Colors.blue,
//                           fontWeight: FontWeight.bold,fontSize: 16),)
//                 ),
//               ),
//             )),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: Icon(Icons.add),
//         onPressed: _showAddDialog,
//       ),
//     );
//   }

//   _showAddDialog() async {
//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: Colors.white70,
//           title: Text("Add Events"),
//           content: TextField(
//             controller: _eventController,
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text("Save",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//               onPressed: () {
//                 if (_eventController.text.isEmpty) return;
//                 setState(() {
//                   if (_events[_controller.selectedDay] != null) {
//                     _events[_controller.selectedDay]
//                         .add(_eventController.text);
//                   } else {
//                     _events[_controller.selectedDay] = [
//                       _eventController.text
//                     ];
//                   }
//                   prefs.setString("events", json.encode(encodeMap(_events)));
//                   _eventController.clear();
//                   Navigator.pop(context);
//                 });

//               },
//             )
//           ],
//         ));
//   }
// }
