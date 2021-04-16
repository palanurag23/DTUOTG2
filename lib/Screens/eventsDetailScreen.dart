import 'package:DTUOTG/models/screenArguments.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; //otherwise context error
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsDetailScreen extends StatefulWidget {
  static const routeName = '/EventsDetailScreen';
  EventsDetailScreen({Key key}) : super(key: key);

  @override
  _EventsDetailScreenState createState() => _EventsDetailScreenState();
}

class _EventsDetailScreenState extends State<EventsDetailScreen> {
  bool initialized = false;
  bool waiting = true;
  Map<String, dynamic> resp;
  @override
  void didChangeDependencies() async {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    int eventID = args.id;
    if (!initialized) {
      var accessToken =
          Provider.of<AccessTokenData>(context, listen: false).accessToken;
      var accessTokenValue = accessToken[0];
      Map<String, String> headersEventDetails = {
        "Content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $accessTokenValue"
      };
      http.Response response = await http.get(
        Uri.https('dtu-otg.herokuapp.com', 'events/details/$eventID'),
        headers: headersEventDetails,
      );
      print('/////////$eventID');
      int statusCode = response.statusCode;
      resp = json.decode(response.body);
      print('//////$resp');
      initialized = true;
      setState(() {
        waiting = false;
      });
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eve detail'),
      ),
      body: Container(
        child: Center(
            child: waiting
                ? CircularProgressIndicator()
                : Text(
                    resp.toString(),
                    style: TextStyle(fontSize: 20),
                  )),
      ),
    );
  }
}
