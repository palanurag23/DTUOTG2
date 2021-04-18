import 'package:flutter/material.dart';

class Drawer extends StatelessWidget {
  final statusBarHeight;
  Drawer({this.statusBarHeight});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.amber,
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
