import 'package:flutter/material.dart';
import 'package:itorrent/Apis/HomeScreen.dart';
import 'package:slide_drawer/slide_drawer.dart';

class DrawerHomeSreen extends StatefulWidget {
  final String title;
  const DrawerHomeSreen({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _DrawerHomeSreenState createState() => _DrawerHomeSreenState();
}

class _DrawerHomeSreenState extends State<DrawerHomeSreen> {
  bool isSwitched_1337xProvider = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SlideDrawer(
        offsetFromRight: 100.0,
        alignment: SlideDrawerAlignment.center,
        // headDrawer: Container(
        //   alignment: Alignment.topLeft,
        //   padding: EdgeInsets.fromLTRB(50, 10, 0, 0),
        //   height: 50,
        //   width: 50,
        //   child: Image(
        //       image:
        //           NetworkImage("https://static.seedr.cc/images/seed_v2.png")),
        // ),

        items: [
          MenuItem('Login', icon: Icons.login, onTap: () {
            Navigator.pushNamed(context, '/login');
          }),
          MenuItem(
            '1337x Provider',
            //icon: Icons.home,
            leading: Switch(
                value: isSwitched_1337xProvider,
                onChanged: (value) {
                  print("VALUE : $value");
                  setState(() {
                    isSwitched_1337xProvider = value;
                  });
                }),
          ),
        ],
        brightness: Brightness.dark,
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [
            Color(0xFF000046),
            Color(0xFF1CB5E0),
          ],
        ),
        child: HomeScreen(
            title: widget.title,
            isSwitched_1337xProvider: isSwitched_1337xProvider),
      );
    });
  }
}
