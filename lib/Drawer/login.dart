import 'package:flutter/material.dart';
import 'package:itorrent/Apis/torrentSearchClass/GetMagnetLink.dart';
import 'package:itorrent/Apis/web_seedr/customtabseedr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetMagnetLink getMagnetLink = GetMagnetLink();
  CustomTabSeedr customTabSeedr = CustomTabSeedr();

  bool isLogin = true;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isLogin ? Text('Logout') : Text('Login'),
        ),
        body: isLogin
            ? Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          var data =
                              await getMagnetLink.getSharedPreferencesData();

                          setState(() {
                            emailController.text = data[0];
                            passwordController.text = data[1];
                            isLogin = false;
                          });
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // await prefs.remove('email');
                          // await prefs.remove('password');
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                ),
              )
            : buildPaddingLoginSreen());
  }

  Padding buildPaddingLoginSreen() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'iTorrent',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Link your Seedr account for automation',
                  style: TextStyle(fontSize: 15),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Connect'),
                  onPressed: () {
                    saveSeedrCredantial();
                  },
                )),
            Container(
                child: Row(
              children: <Widget>[
                Text('Does not have account?'),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(
                    'Create',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    customTabSeedr.launchURL(context);
                    //signup screen
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
          ],
        ));
  }

  Future saveSeedrCredantial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    var l =
        "magnet:?xt=urn:btih:EDB724BCEDBC036467A6422234267C95EC55394E&dn=Game+of+Thrones+S08E01+WEB+H264-MEMENTO+%5Beztv%5D&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftorrent.gresille.org%3A80%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2710%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcoppersurfer.tk%3A6969%2Fannounce";
    var statuse = await getMagnetLink.addMagnetLinkinSeedr(l);
    if (statuse == true) {
      setState(() {
        isLogin = true;
      });
    } else {}
  }
}
