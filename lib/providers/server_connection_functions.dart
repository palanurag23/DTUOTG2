import 'package:DTUOTG/models/events.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
//import 'package:path/path.dart' as path; //otherwise context error

class Server_Connection_Functions {
  Future<bool> registerForEvent(
    int eventId,
    BuildContext context,
  ) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersRegisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/register/'),
        headers: headersRegisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK" ? true : false; //return registration status
  }

  Future<bool> unregisterForEvent(int eventId, BuildContext context) async {
    String username =
        Provider.of<UsernameData>(context, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(context, listen: false).getAccessToken();
    Map<String, String> headersUnregisterEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {
      "username": "$username",
      "event_id": "$eventId",
    };
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/unregister/'),
        headers: headersUnregisterEvent,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code unregister event $statusCode');

    print(response.body);
    Map<String, dynamic> resp = json.decode(response.body);
    if (resp['status'] == "OK")
      Provider.of<EventsData>(context, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK"
        ? false
        : true; //return registration status not unregistration status
  }

  Future<bool> fetchListOfEvents(BuildContext context) async {
    List<Event> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(context, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    Map<String, String> headersEvents = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    http.Response response = await http.get(
      Uri.https('dtu-otg.herokuapp.com', 'events'),
      headers: headersEvents,
    );
    int statusCode = response.statusCode;
    List<dynamic> resp = json.decode(response.body);
    eves = resp.map<Event>((e) {
      return Event(
        favorite: e['registered'],
        name: e['name'],
        owner: e['owner'],
        id: e['id'],
        eventType: e['type_event'],
        dateime: DateTime.parse(e['date_time']),
      );
    }).toList();
    Provider.of<EventsData>(context, listen: false).setEvents(eves);
    print(resp);
    return true;
  }
}
