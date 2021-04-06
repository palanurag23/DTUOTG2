import '../helper/db_helper.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';

class AccessTokenData with ChangeNotifier {
  List<String> accessToken = [];
  List<DateTime> dateTime = [];
  //List<String> unit = [];
  void addAccessToken(String accessToken) async {
    this.accessToken = [accessToken];
    this.dateTime = [DateTime.now()];
    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertAccessToken('AccessToken', {
      'id': 'id',
      'accessToken': accessToken,
      'dateTime': dateTime[0].toIso8601String()
    });
    notifyListeners();
  }

  Future<void> fetchAndSetData() async {
    print('fetching Access token');
    var accessTokenData = await DbHelper.getAccessTokenData();
    if (accessTokenData.isEmpty) {
      print('....................................empty accessTokenDatabase');
    } else {
      print(accessTokenData);

      accessToken = [(accessTokenData[0]['accessToken'])];
      dateTime = [DateTime.parse(accessTokenData[0]['dateTime'])];

      print('................Height fetched and set$accessToken');
    }
    notifyListeners();
  }
}
