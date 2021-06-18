import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:itorrent/Apis/torrentSearchClass/GetMagnetLink.dart';
import '../auto_search_complete_helper_fun.dart';
import 'web_seedr/customtabseedr.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:slide_drawer/slide_drawer.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final bool isSwitched_1337xProvider;
  const HomeScreen({
    Key key,
    @required this.title,
    this.isSwitched_1337xProvider,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetMagnetLink getMagnetLink = GetMagnetLink();
  CustomTabSeedr customTabSeedr = CustomTabSeedr();
  final suggesionController = TextEditingController();
  //var _autoValidate = false;
  var _search;

  List data;
  bool isLoading = false;
  var statusCode;
  bool isEnableTile = true;
  int snackBarCounter = 1;
  bool seedrConnected = false;
  bool isSearching = false;
  bool isSwitched = false;
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
          title: isSearching
              ? buildListTileTextFormFieldSearch()
              : Center(
                  child: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
          leading: IconButton(
            icon: Icon(Icons.menu),
            // call toggle from SlideDrawer to alternate between open and close
            // when pressed menu button
            onPressed: () => SlideDrawer.of(context).toggle(),
          ),
          actions: [
            isSearching
                ? Center()
                : IconButton(
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                    icon: Icon(Icons.search))
          ],
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     children: [
        //       UserAccountsDrawerHeader(
        //         accountName: Text("mandalbis1729@gmail.com"),
        //         currentAccountPicture: CircleAvatar(
        //             backgroundColor: Colors.grey,
        //             child: Image.network(
        //                 "https://static.seedr.cc/images/seed_v2.png")),
        //         accountEmail: null,
        //       ),
        //       ListTile(
        //         title: Text("Home"),
        //         trailing: Icon(Icons.home),
        //         onTap: () => Navigator.of(context).pop(),
        //       ),
        //       ListTile(
        //         title: Text("Login"),
        //         trailing: Icon(Icons.login),
        //         onTap: () => Navigator.of(context).pushNamed("/login"),
        //       )
        //     ],
        //   ),
        // ),
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
                              Text('No results to display',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
            ],
          ),
        ));
  }

  TypeAheadField buildListTileTextFormFieldSearch() {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          onSubmitted: (value) {
            setState(() {
              isLoading = true;
              isEnableTile = false;
            });
            searchResults(value);
          },
          // textInputAction: TextInputAction.done,
          controller: this.suggesionController,
          autofocus: true,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                });
              },
              icon: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            filled: true,
            fillColor: Colors.white70,
          )),
      suggestionsCallback: (pattern) async {
        _search = pattern;

        return await getSuggestion(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
            leading: Icon(Icons.search),
            title: Text(
              suggestion,
              style: TextStyle(fontSize: 15),
            ));
      },
      onSuggestionSelected: (suggestion) {
        suggesionController.text = suggestion;
        FocusScope.of(context).unfocus();
        print(suggestion);

        setState(() {
          isLoading = true;
          isEnableTile = false;
        });
        searchResults(suggestion);
        setState(() {
          seedrConnected = !seedrConnected;
        });
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ProductPage(product: suggestion)));
      },
    );
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
                        seedrConnected ? Icons.cloud_done : Icons.cloud_off),
                    title: Text(
                      data[index]["title"],
                      style: TextStyle(fontSize: 15.0),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(child: Text(data[index]["provider"])),
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              "Seedr: ",
                            ),
                            data[index]["seeds"] < 10
                                ? Text(
                                    data[index]["seeds"].toString(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    data[index]["seeds"].toString(),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                          ],
                        )),
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
