import 'package:flutter/material.dart';
import 'package:itorrent/Drawer/login.dart';

import 'Apis/HomeScreen.dart';

import 'Drawer/DrawerHomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'iTorrent';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.grey, accentColor: Colors.black),
      home: DrawerHomeSreen(title: title),
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => LoginScreen(),
        "/app": (BuildContext context) => MyApp(),
        "/home": (BuildContext context) => HomeScreen(
              title: title,
            ),
      },
    );
  }
}

//----------optimize size-----------
//flutter build apk --split-per-abi
