import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  String name;
  int id;
  bool favorite;
  String owner;
  DateTime dateime;
  String eventType;
  Event(
      {this.dateime,
      this.eventType,
      this.id,
      this.name,
      this.owner,
      this.favorite});
}
