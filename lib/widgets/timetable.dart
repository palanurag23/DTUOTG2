import 'package:flutter/material.dart';
import '../models/lecture.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Lecture> lectures = [];
  bool initialized = false;

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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7),
      child: !initialized
          ? CircularProgressIndicator()
          : lectures.isEmpty
              ? Text('empty')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ToggleSwitch(
                      minWidth: 150,
                      cornerRadius: 25,
                      initialLabelIndex: weekDayIndex - 1,
                      onToggle: (index) {
                        weekDayIndex = index + 1;
                        setState(() {
                          lectures =
                              Provider.of<TimeTableData>(context, listen: false)
                                  .get(index + 1);
                          print(index);
                        });
                      },
                      labels: ['mo', 'tu', 'wed', 'th', 'fr'],
                      activeBgColor: Colors.blueGrey[900],
                      activeFgColor: Colors.amber,
                      inactiveFgColor: Colors.white,
                      inactiveBgColor: Colors.grey[900],
                    ),
                    Expanded(
                      child: new ListView.builder(
                        itemBuilder: (context, index) {
                          int hour = lectures[index].time.hour;
                          int length = lectures[index].length;
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                                leading: lectures[index].time.hour ==
                                        TimeOfDay.now().hour
                                    ? Text(
                                        'now',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Icon(Icons.access_time_outlined),
                                subtitle: Text('$hour-${hour + length}'),
                                tileColor: lectures[index].free
                                    ? Colors.red
                                    : lectures[index].time.hour ==
                                            TimeOfDay.now().hour
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          );
                        },
                        itemCount: lectures.length,
                      ),
                    ),
                  ],
                ),
      // ListView.builder(
      //   itemBuilder: (context, index) {
      //     print('///////${sheduled.length}');
      //     return ListTile(
      //       subtitle: Text(
      //         '${sheduled[index].dateime.toString()}',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       title: Text(
      //         '${sheduled[index].name}',
      //         style: TextStyle(color: Colors.amber),
      //       ),
      //     );
      //   },
      //   itemCount: sheduled.length,
      // ),
    );
  }
}
