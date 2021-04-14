import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeTab extends StatefulWidget {
  final height;
  final statusBarHeight;
  HomeTab({this.height, this.statusBarHeight});
  @override
  _HomeTabState createState() => _HomeTabState();
}

int events0Schedule1 = 0;

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'HOME',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                // SizedBox(
                //   height: widget.statusBarHeight +
                //       (((widget.height * 0.3) - widget.statusBarHeight) * 0.10),
                // ),
                ToggleSwitch(
                  initialLabelIndex: events0Schedule1,
                  onToggle: (index) {
                    setState(() {
                      events0Schedule1 = index;
                    });
                  },
                  labels: ['events', 'shedule'],
                  activeBgColor: Colors.black,
                  activeFgColor: Colors.amber,
                  inactiveFgColor: Colors.white,
                  inactiveBgColor: Colors.grey[900],
                )
              ],
            ),
            padding: EdgeInsets.only(
              top: widget.statusBarHeight +
                  (((widget.height * 0.3) - widget.statusBarHeight) * 0.10),
              // left: 20,
              // right: 20,
              // bottom: (widget.height * 0.3 - widget.statusBarHeight) * 0.10
            ),
            height: widget.height * 0.2,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  events0Schedule1 == 0 ? 'events' : 'schedule',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                      color: Colors.amberAccent),
                ),
              ),
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
