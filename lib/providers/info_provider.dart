import 'package:DTUOTG/models/events.dart';

import '../helper/db_helper.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';

class EventsData with ChangeNotifier {
  DateTime lastRefreshed = DateTime(2000);
  setLastRefreshed() {
    lastRefreshed = DateTime.now();
  }

  DateTime getLastRefreshed() {
    return lastRefreshed;
  }

  List<Event> events = [
    Event(
        dateime: DateTime.now(),
        eventType: 'education',
        favorite: true,
        id: 1,
        name: 'french seminar',
        owner: 'french'),
    Event(
        dateime: DateTime.now(),
        eventType: 'cultural',
        id: 2,
        favorite: false,
        name: 'fest',
        owner: 'name1'),
    Event(
        dateime: DateTime.now(),
        eventType: 'cultural',
        id: 3,
        name: 'workshop',
        favorite: true,
        owner: 'name2'),
    Event(
        dateime: DateTime.now(),
        eventType: '',
        id: 4,
        name: 'event',
        favorite: false,
        owner: 'name3')
  ];
  changeFavoriteStatus(int id) {
    int index = events.indexWhere(
      (element) => element.id == id,
    );

    Event e = Event(
        name: events[index].name,
        owner: events[index].owner,
        id: events[index].id,
        eventType: events[index].eventType,
        dateime: events[index].dateime,
        favorite: !events[index].favorite);
    events[index] = e;
    notifyListeners();
  }

  setEvents(List<Event> events) {
    this.events = events;
    notifyListeners();
  }

  List<Event> getEvents() {
    return events;
  }
}

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

  Future<bool> deleteAccessToken() async {
    int result = await DbHelper.deleteAccessTokenData('id');
    if (result >= 1) {
      return true;
    }
    return false;
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
      'name': name[0],
      'rollNumber': rollNumber.toString(),
      'branch': branch[0],
      'year': year.toString(),
      'batch': batch[0]
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

//
class UsernameData with ChangeNotifier {
  List<String> username = [];

  void addUsername(String username) async {
    this.username = [username];

    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertUsername('username', {'id': 'id', 'username': username});
    notifyListeners();
  }

  Future<void> fetchAndSetData() async {
    print('fetching username');
    var usernameData = await DbHelper.getUsernameData();
    if (usernameData.isEmpty) {
      print('....................................empty username');
    } else {
      print(usernameData);

      username = [(usernameData[0]['username'])];

      print('................user name fetched and set$username');
    }
    notifyListeners();
  }
}

//
class OwnerIdData with ChangeNotifier {
  List<int> ownerID = [];

  void addOwnerId(int id) async {
    this.ownerID = [id];

    // DbHelper.deleteSingleHeight('id');
    DbHelper.insertOwnerId('ownerId', {'id': 'id', 'ownerId': id});
    notifyListeners();
  }

  Future<void> fetchAndSetData() async {
    print('fetching ownerId');
    var ownerIdData = await DbHelper.getOwnerIdData();
    if (ownerIdData.isEmpty) {
      print('....................................empty ownerid');
    } else {
      print(ownerIdData);

      ownerID = [(ownerIdData[0]['ownerId'])];

      print('................ownerID fetched and set$ownerID');
    }
    notifyListeners();
  }
}

class AddEventScreenData with ChangeNotifier {
  int hours = 1;
  //int owner = 1;
  int minutes = 0;
  setHours(int hours) {
    this.hours = hours;
    notifyListeners();
  }

  // setOwner(int owner) {
  //   this.owner = owner;
  //   notifyListeners();
  // }

  setMinutes(int minutes) {
    this.minutes = minutes;
    notifyListeners();
  }

  // int getOwners() {
  //   return owner;
  // }

  int getMinutes() {
    return minutes;
  }

  int getHours() {
    return hours;
  }
}
