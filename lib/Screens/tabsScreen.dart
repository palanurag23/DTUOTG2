import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabsScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '''loged in,tabs screen
WELCOME
  TO  
DTU OTG''',
          style: TextStyle(fontSize: 22, color: Colors.green),
        ),
      ),
    );
  }
}
