import 'package:DTUOTG/models/events.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/info_provider.dart';
//import 'package:path/path.dart' as path; //otherwise context error

class Server_Connection_Functions {
  BuildContext myAppContext;
  Server_Connection_Functions(this.myAppContext);

  Future<bool> registerForEvent(
    int eventId,
  ) async {
    String username =
        Provider.of<UsernameData>(myAppContext, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false)
            .getAccessToken();
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
      Provider.of<EventsData>(myAppContext, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK" ? true : false; //return registration status
  }

  Future<bool> unregisterForEvent(int eventId) async {
    String username =
        Provider.of<UsernameData>(myAppContext, listen: false).username[0];
    String accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false)
            .getAccessToken();
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
      Provider.of<EventsData>(myAppContext, listen: false)
          .changeFavoriteStatus(eventId);
    return resp['status'] == "OK"
        ? false
        : true; //return registration status not unregistration status
  }

  Future<bool> fetchListOfEvents() async {
    List<Event> eves = [];
    var accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false).accessToken;
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
    Provider.of<EventsData>(myAppContext, listen: false).setEvents(eves);
    print(resp);
    return true;
  }

  Future<dynamic> createEvent(String name, String description, int type,
      DateTime dateTime, TimeOfDay timeOfDay) async {
    int hours =
        Provider.of<AddEventScreenData>(myAppContext, listen: false).getHours();
    int minutes = Provider.of<AddEventScreenData>(myAppContext, listen: false)
        .getMinutes();
    var accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    await Provider.of<OwnerIdData>(myAppContext, listen: false)
        .fetchAndSetData();
    int owner =
        Provider.of<OwnerIdData>(myAppContext, listen: false).ownerID[0];
    Map<String, String> headersCreateEvent = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    DateTime date_time = DateTime(dateTime.year, dateTime.month, dateTime.day,
        timeOfDay.hour, timeOfDay.minute);
    Map mapjsonBody = {
      "owner": owner,
      "name": "$name",
      "description": "$description",
      "date_time": "${date_time.toIso8601String()}",
      "duration": "$hours:$minutes:00",
      "latitude": "27.204600000",
      "longitude": "77.497700000",
      "type_event": "${type.toString()}",
      "user_registered": true
    };
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'events/create/'),
        headers: headersCreateEvent,
        body: json.encode(mapjsonBody));
    print('///////resp CREATE EVENT  ${response.body}');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }

  Future<dynamic> invite(
    String email,
  ) async {
    String accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false)
            .getAccessToken();
    Map<String, String> headersInvite = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    Map mapjsonBody = {"email": "$email"};
    http.Response response = await http.post(
        Uri.https('dtu-otg.herokuapp.com', 'auth/send-email/'),
        headers: headersInvite,
        body: json.encode(mapjsonBody));
    print(json.encode(mapjsonBody));
    int statusCode = response.statusCode;
    print('//////status code register event $statusCode');
    Map<String, dynamic> resp = json.decode(response.body);
    return resp;
  }

  Future<Map<String, dynamic>> timeTableDownload() async {
    var accessToken =
        Provider.of<AccessTokenData>(myAppContext, listen: false).accessToken;
    var accessTokenValue = accessToken[0];
    print('1');

    Map<String, String> headersTimeTable = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer $accessTokenValue"
    };
    print('2');
    http.Response response = await http.get(
      Uri.https('dtu-otg.herokuapp.com', 'timetable/',
          {"year": "2k19", "batchgrp": "A", "batchnum": "1"}),
      headers: headersTimeTable,
    );
    print('3');
    int statusCode = response.statusCode;

    Map<String, dynamic> resp = json.decode(json.decode(response.body));
    print(statusCode);
    print(resp.toString());
    DateTime.now().weekday;
    //
    List x = resp['MON']['2-3'];
    String i = x == null ? 'null' : x[0];
    print(i);
    //
    return resp;
  }
}
