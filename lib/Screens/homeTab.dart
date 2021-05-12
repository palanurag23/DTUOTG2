import 'package:DTUOTG/models/events.dart';
import 'package:DTUOTG/models/lecture.dart';
import 'package:DTUOTG/models/screenArguments.dart';
import 'package:DTUOTG/providers/server_connection_functions.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart' as path; //otherwise context error
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
  List<Event> evesForSchedule = [];
  List<Lecture> lectures = [];
  List<Event> sheduled = []; ////not implemented globally...only on home tab
  var scf;
  BuildContext bc;
  @override
  void didChangeDependencies() async {
    print('home init');
    if (!eventsInitialized) {
      scf = Provider.of<SCF>(context, listen: false).get();
      bc = Provider.of<TabsScreenContext>(context, listen: false).get();
      await scf.fetchListOfEvents(bc);
      await scf.timeTableDownload(bc);
      evesForSchedule = Provider.of<EventsData>(context, listen: false).events;
      // var lastRefreshedTime =
      //     Provider.of<EventsData>(context, listen: false).getLastRefreshed();
      // int x = DateTime.now().difference(lastRefreshedTime).inSeconds;
      //   print('/////////////diff x$x');
      // if (x > 10) {
      //   var accessToken =
      //       Provider.of<AccessTokenData>(context, listen: false).accessToken;
      //   var accessTokenValue = accessToken[0];
      //   Map<String, String> headersEvents = {
      //     "Content-type": "application/json",
      //     "accept": "application/json",
      //     "Authorization": "Bearer $accessTokenValue"
      //   };
      //   http.Response response = await http.get(
      //     Uri.https('dtu-otg.herokuapp.com', 'events'),
      //     headers: headersEvents,
      //   );
      //   int statusCode = response.statusCode;
      //   List<dynamic> resp = json.decode(response.body);
      //   eves = resp.map<Event>((e) {
      //     return Event(
      //       favorite: e['registered'],
      //       name: e['name'],
      //       owner: e['owner'],
      //       id: e['id'],
      //       eventType: e['type_event'],
      //       dateime: DateTime.parse(e['date_time']),
      //     );
      //   }).toList();
      //   Provider.of<EventsData>(context, listen: false).setEvents(eves);
      //   print(resp);
      // }
      lectures = Provider.of<TimeTableData>(context, listen: false).get();
      sheduled = [];
      evesForSchedule.forEach((element) {
        if (element.favorite) {
          sheduled.add(element);
        }
      });
      //  Provider.of<EventsData>(context, listen: false).setLastRefreshed();
      setState(() {
        eventsInitialized = true;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('home');
    var _addEventButton = new FloatingActionButton.extended(
      onPressed: () {
        print('.floating action button');
        Navigator.of(context).pushNamed(
          'AddEventScreen',
        );
      },
      label: Text('add'),
      icon: Icon(Icons.add),
    );

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
                  minWidth: 150,
                  cornerRadius: 25,
                  initialLabelIndex: events0Schedule1,
                  onToggle: (index) {
                    setState(() {
                      events0Schedule1 = index;
                    });
                  },
                  labels: ['events', 'schedule'],
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
                    ? Stack(
                        children: [
                          Container(
                            child: eventsInitialized
                                ? RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {
                                        eventsInitialized = false;
                                      });
                                      await scf.fetchListOfEvents(bc);
                                      evesForSchedule = Provider.of<EventsData>(
                                              context,
                                              listen: false)
                                          .events;
                                      sheduled = [];
                                      evesForSchedule.forEach((element) {
                                        if (element.favorite) {
                                          sheduled.add(element);
                                        }
                                      });
                                      setState(() {
                                        eventsInitialized = true;
                                      });
                                    },
                                    child: ListView.builder(
                                        itemCount:
                                            Provider.of<EventsData>(context)
                                                .events
                                                .length,
                                        itemBuilder: (context, index) {
                                          var events =
                                              Provider.of<EventsData>(context)
                                                  .events;
                                          return ListTile(
                                            tileColor: events[index].favorite
                                                ? Colors.redAccent
                                                : Colors.blueGrey[900],
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/EventsDetailScreen',
                                                  arguments: ScreenArguments(
                                                      id: events[index].id,
                                                      scf: scf,
                                                      context: context));
                                            },
                                            subtitle: Text(
                                              events[index].eventType,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: Icon(
                                              Icons.ac_unit,
                                              color: Colors.blue,
                                            ),
                                            title: Text(
                                              events[index].name,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'loading events  ',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                          ),
                          if (eventsInitialized)
                            Positioned(
                              child: _addEventButton,
                              bottom: 20,
                              right: 20,
                            ),
                        ],
                      )
                    : Container(
                        child: !eventsInitialized
                            ? CircularProgressIndicator()
                            : lectures.isEmpty
                                ? Text('empty')
                                : ListView.builder(
                                    itemBuilder: (context, index) {
                                      int hour = lectures[index].time.hour;
                                      int length = lectures[index].length;
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: ListTile(
                                            leading: lectures[index]
                                                        .time
                                                        .hour ==
                                                    TimeOfDay.now().hour
                                                ? Text(
                                                    'now',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Icon(
                                                    Icons.access_time_outlined),
                                            subtitle:
                                                Text('$hour-${hour + length}'),
                                            tileColor: lectures[index].free
                                                ? Colors.red
                                                : lectures[index].time.hour ==
                                                        TimeOfDay.now().hour
                                                    ? Colors.tealAccent[400]
                                                    : Colors.amberAccent[100],
                                            title: lectures[index].free
                                                ? Text(
                                                    'FREE',
                                                    style: TextStyle(
                                                        color: Colors.yellow),
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
