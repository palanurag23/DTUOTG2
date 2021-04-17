import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:path/path.dart' as path; //otherwise context error

class Server_Connection_Functions {
  Future<bool> registerForEvent(
      int eventId, String username, String accessToken) async {
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

    return resp['status'] == "OK" ? true : false; //return registration status
  }

  Future<bool> unregisterForEvent(
      int eventId, String username, String accessToken) async {
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

    return resp['status'] == "OK"
        ? false
        : true; //return registration status not unregistration status
  }
}
