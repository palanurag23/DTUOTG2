import 'package:DTUOTG/Screens/authScreen.dart';
import 'package:DTUOTG/Screens/enterDetailsScreen.dart';
import 'package:DTUOTG/Screens/loadingScreen.dart';
import 'package:DTUOTG/Screens/tabsScreen.dart';
import 'package:DTUOTG/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AccessTokenData())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoadingScreen(),
        //AuthScreen(),
        routes: {
          '/AuthScreen': (context) => AuthScreen(),
          '/EnterDetailsScreen': (context) => EnterDetailsScreen(),
          '/TabsScreen': (context) => TabsScreen()
        },
      ),
    );
  }
}
