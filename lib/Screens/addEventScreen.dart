import 'package:flutter/material.dart';

import 'package:time_range_picker/time_range_picker.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = 'AddEventScreen';
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  bool waiting = false;
  final name = TextEditingController();
  DateTime now = DateTime.now();
  Duration _duration = Duration(hours: 0, minutes: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add event'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  TimeRange result = await showTimeRangePicker(
                      clockRotation: 0,
                      context: context,
                      start: TimeOfDay(hour: 0, minute: 0),
                      end: TimeOfDay(hour: 18, minute: 0),
                      // disabledTime: TimeRange(
                      //     startTime: TimeOfDay(hour: 22, minute: 0),
                      //     endTime: TimeOfDay(hour: 5, minute: 0)),
                      disabledColor: Colors.red.withOpacity(0.5),
                      strokeWidth: 8,
                      handlerColor: Colors.red,
                      backgroundColor: Colors.grey[100],
                      ticks: 24,
                      strokeColor: Colors.amber,
                      selectedColor: Colors.amberAccent,
                      paintingStyle: PaintingStyle.fill,
                      ticksOffset: -7,
                      ticksLength: 50,
                      ticksColor: Colors.grey,
                      labels: [
                        "00:00",
                        "3 am",
                        "6 am",
                        "9 am",
                        "12 am",
                        "3 pm",
                        "6 pm",
                        "9 pm"
                      ].asMap().entries.map((e) {
                        return ClockLabel.fromIndex(
                            idx: e.key, length: 8, text: e.value);
                      }).toList(),
                      labelOffset: 35,
                      rotateLabels: true,
                      padding: 60);

                  print("result " + result.toString());
                },
                child: Text("rangeTimes"),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
