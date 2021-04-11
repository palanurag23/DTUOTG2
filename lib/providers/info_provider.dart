import '../helper/db_helper.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';

class AccessTokenData with ChangeNotifier {
  List<String> accessToken = [];

  List<DateTime> dateTime = [];
  setTokenAndDate(String accessToken) {
    this.accessToken = [accessToken];
    dateTime = [DateTime.now()];
  }

  String getAccessToken() {
    return accessToken[0];
  }

  DateTime getDateTime() {
    return dateTime.isEmpty ? DateTime.now() : dateTime[0];
  }

  //List<String> unit = [];
  void addAccessToken(String accessToken, DateTime dateTime) async {
    this.accessToken = [accessToken];
    this.dateTime = [dateTime];
    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertAccessToken('AccessToken', {
      'id': 'id',
      'accessToken': accessToken,
      'dateTime': this.dateTime[0].toIso8601String()
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

      print('................access token fetched and set$accessToken');
    }
    notifyListeners();
  }
}

class EmailAndUsernameData with ChangeNotifier {
  List<String> username = [];
  List<String> email = [];

  void addEmailAndUsername(String email, String username) async {
    this.email = [email];
    this.username = [username];
    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertEmailAndUsername(
        'EmailAndUsername', {'id': 'id', 'email': email, 'username': username});
    notifyListeners();
  }

  Future<void> fetchAndSetData() async {
    print('fetching email and username');
    var emailAndUsernameData = await DbHelper.getEmailAndUsername();
    if (emailAndUsernameData.isEmpty) {
      print('....................................empty email And username');
    } else {
      print(emailAndUsernameData);

      email = [(emailAndUsernameData[0]['email'])];
      username = [emailAndUsernameData[0]['username']];

      print(
          '................email and username fetched and set $email $username');
    }
    notifyListeners();
  }
}

class ProfileData with ChangeNotifier {
  List<String> name = [];
  List<String> branch = [];
  List<String> batch = [];
  List<int> year = [];
  List<int> rollNumber = [];
  void addProfile(String name, String branch, String batch, int year,
      int rollNumber) async {
    this.name = [name];
    this.branch = [branch];
    this.batch = [batch];
    this.year = [year];
    this.rollNumber = [rollNumber];
    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertEmailAndUsername('Profile', {
      'id': 'id',
      'name': name,
      'rollNumber': rollNumber.toString(),
      'branch': branch,
      'year': year.toString(),
      'batch': batch
    });
    notifyListeners();
  }

  String getBatch() {
    return batch.isEmpty ? ' ' : batch[0];
  }

  String getBranch() {
    return branch.isEmpty ? ' ' : branch[0];
  }

  int getYear() {
    return year.isEmpty ? 0 : year[0];
  }

  int getRollNumber() {
    return rollNumber.isEmpty ? 0 : rollNumber[0];
  }

  void saveSetedChanges() {
    DbHelper.insertEmailAndUsername('Profile', {
      'id': 'id',
      'name': name,
      'rollNumber': rollNumber.toString(),
      'branch': branch,
      'year': year.toString(),
      'batch': batch
    });
    notifyListeners();
  }

  setBranch(String branch) {
    this.branch = [branch];
    notifyListeners();
  }

  setBatch(String batch) {
    this.batch = [batch];
    notifyListeners();
  }

  setYear(int year) {
    this.year = [year];
    notifyListeners();
  }

  setName(String name) {
    this.name = [name];
    notifyListeners();
  }

  setRollNumber(int rollNumber) {
    this.rollNumber = [rollNumber];
    notifyListeners();
  }

  Future<void> fetchAndSetData() async {
    print('fetching profile');
    var profileData = await DbHelper.getEmailAndUsername();
    if (profileData.isEmpty) {
      print('....................................empty profile');
    } else {
      print(profileData);

      name = [(profileData[0]['name'])];
      rollNumber = [int.parse(profileData[0]['rollNumber'])];
      branch = [(profileData[0]['branch'])];
      batch = [(profileData[0]['batch'])];
      year = [int.parse(profileData[0]['year'])];
      print('................email and username fetched and set $profileData');
    }
    notifyListeners();
  }
}
