import 'package:flutter/material.dart';

class EnterDetailsScreen extends StatefulWidget {
  static const routeName = '/EnterDetailsScreen';
  @override
  _EnterDetailsScreenState createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'signed up,enter details',
          style: TextStyle(fontSize: 22, color: Colors.green),
        ),
      ),
    );
  }
}
