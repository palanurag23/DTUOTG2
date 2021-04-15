import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //otherwise context error
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import '../providers/info_provider.dart';
import 'dart:convert';

import '../providers/info_provider.dart';

class HomeTab extends StatefulWidget {
  final height;
  final statusBarHeight;
  HomeTab({this.height, this.statusBarHeight});
  @override
  _HomeTabState createState() => _HomeTabState();
}

int events0Schedule1 = 0;

class _HomeTabState extends State<HomeTab> {
  bool eventsInitialized = false;
  @override
  void didChangeDependencies() async {
    if (!eventsInitialized) {
      var lastRefreshedTime =
          Provider.of<EventsData>(context, listen: false).getLastRefreshed();
      int x = DateTime.now().difference(lastRefreshedTime).inSeconds;
      print('/////////////diff x$x');
      if (x > 10) {
        var accessToken =
            Provider.of<AccessTokenData>(context, listen: false).accessToken;
        var accessTokenValue = accessToken[0];
        Map<String, String> headersEvents = {
          "Content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer $accessTokenValue"
        };
        http.Response response = await http.get(
          Uri.https('dtu-otg.herokuapp.com', 'auth/profile'),
          headers: headersEvents,
        );
        int statusCode = response.statusCode;
        var resp = json.decode(response.body);
      }
      Provider.of<EventsData>(context, listen: false).setLastRefreshed();
      setState(() {
        eventsInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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
                child: events0Schedule1 == 0
                    ? Container(
                        child: eventsInitialized
                            ? ListView.builder(
                                itemCount: Provider.of<EventsData>(context)
                                    .events
                                    .length,
                                itemBuilder: (context, index) {
                                  var events =
                                      Provider.of<EventsData>(context).events;
                                  return ListTile(
                                    subtitle: Text(
                                      events[index].eventType,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.ac_unit,
                                      color: Colors.blue,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Provider.of<EventsData>(context,
                                                listen: false)
                                            .changeFavoriteStatus(
                                                events[index].id);
                                      },
                                      icon: Icon(
                                        events[index].favorite
                                            ? Icons.favorite
                                            : Icons.favorite_border_rounded,
                                        color: events[index].favorite
                                            ? Colors.red
                                            : Colors.amber,
                                      ),
                                    ),
                                    title: Text(
                                      events[index].name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                })
                            : CircularProgressIndicator(),
                      )
                    : Container(),
              ),
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
