import 'package:flutter/material.dart';

import 'Apis/torrentSearch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iTorrent',
      theme: ThemeData(primarySwatch: Colors.grey, accentColor: Colors.black),
      home: Seedr(title: 'iTorrent'),
    );
  }
}

//----------optimize size-----------
//flutter build apk --split-per-abi
