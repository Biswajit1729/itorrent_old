import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:itorrent/Apis/torrentSearchClass/GetMagnetLink.dart';
import 'web_seedr/customtabseedr.dart';

class Seedr extends StatefulWidget {
  final String title;
  const Seedr({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _SeedrState createState() => _SeedrState();
}

class _SeedrState extends State<Seedr> {
  final _formKey = GlobalKey<FormState>();
  GetMagnetLink getMagnetLink = GetMagnetLink();
  CustomTabSeedr customTabSeedr = CustomTabSeedr();

  var _autoValidate = false;
  var _search;

  List data;
  bool isLoading = false;
  var statusCode;
  bool isEnableTile = true;
  int snackBarCounter = 1;

  @override
  void initState() {
    super.initState();
  }
  //static var endpointUrl = 'https://www.myurl.com/api/v1/user';

  Future searchResults(_search) async {
    String endpointUrl = "https://torrsearch-seedr.herokuapp.com/10/";
    Map<String, String> queryParams = {'q': _search};
    String queryString = Uri(queryParameters: queryParams).query;
    final requestUrl = endpointUrl + '?' + queryString;

    print("success: " + _search);
    var res = await http.get(Uri.parse(requestUrl));
    var convertDatatoJson = json.decode(res.body);
    setState(() {
      data = convertDatatoJson;
      print(isLoading);
      isLoading = false;
      isEnableTile = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            widget.title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            customTabSeedr.launchURL(context);
          },
          child: Icon(
            Icons.cloud_done,
            color: Colors.black,
            size: 30,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Column(
            children: [
              Card(
                child: Form(
                  key: _formKey,
                  // ignore: deprecated_member_use
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(0.0)),
                      Image(
                        image: AssetImage("images/logo.png"),
                        width: 200.0,
                        height: 90.0,
                      ),
                      ListTile(
                        // leading: Icon(Icons.search),
                        title: TextFormField(
                          onChanged: (value) {
                            _search = value;
                          },
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Enter Something";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Search",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search)),
                        ),
                      ),
                      ButtonTheme(
                        height: 40.0,
                        minWidth: 300.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (isEnableTile) {
                              FocusScope.of(context).unfocus();
                              final isValid = _formKey.currentState.validate();
                              if (isValid) {
                                setState(() {
                                  isLoading = true;
                                  isEnableTile = false;
                                });
                                searchResults(_search);
                              } else {
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            }
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      )
                    ],
                  ),
                ),
              ),
              isLoading ? CircularProgressIndicator() : Center(),
              data != null
                  ? Expanded(child: listView())
                  : isLoading
                      ? Center()
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 110.0,
                              ),
                              Text(
                                'No results to dislplay',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
            ],
          ),
        ));
  }

  Widget listView() {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            color: Colors.grey,
            child: Column(
              children: [
                Card(
                  //color: Colors.grey[300],
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_download,
                      color: Colors.black,
                    ),
                    title: Text(
                      data[index]["title"],
                      style: TextStyle(fontSize: 15.0),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(child: Text(data[index]["provider"])),
                        Expanded(
                            child: Text(
                                "Seedr: " + data[index]["seeds"].toString())),
                        Expanded(
                            child: Text(
                                "Size: " + data[index]["size"].toString())),
                      ],
                    ),
                    onTap: () async {
                      if (isEnableTile) {
                        setState(() {
                          isLoading = true;
                          isEnableTile = false;
                        });
                        var statusCode = await getMagnetLink.getlink(
                            (index + 1).toString(), _search);
                        if (statusCode == true) {
                          customTabSeedr.launchURL(context);
                          setState(() {
                            isLoading = false;
                            isEnableTile = true;
                            snackBarCounter = 1;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                            isEnableTile = true;
                            snackBarCounter = 1;
                          });
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Container(height: 30, child: Text(statusCode)),
                            action: SnackBarAction(
                              label: 'Delete',
                              onPressed: () {
                                customTabSeedr.launchURL(context);
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else if (snackBarCounter < 2) {
                        snackBarCounter += 1;
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Container(
                              height: 30,
                              child: Center(child: Text("Loading..."))),
                          // action: SnackBarAction(
                          //   label: 'Delete',
                          //   onPressed: () {

                          //   },
                          //),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {}

                      // 5s over, navigate to a new page
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
