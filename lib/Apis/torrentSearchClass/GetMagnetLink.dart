import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GetMagnetLink {
  Future getlink(i, q) async {
    //print("hello");
    String endpointUrl =
        "https://torrsearch-seedr.herokuapp.com/magnetLink/${i}/";
    Map<String, String> queryParams = {'i': i, 'q': q};
    String queryString = Uri(queryParameters: queryParams).query;
    final requestUrl = endpointUrl + '?' + queryString;

    var res = await http.get(Uri.parse(requestUrl));
    String link = res.body;

    print("magnetlink: " + link);
    var statusCode = addMagnetLinkinSeedr(link);
    return statusCode;
    //print("magnetLink: " + magnetLink.toString());
  }

  Future addMagnetLinkinSeedr(l) async {
    var data = await getSharedPreferencesData();
    var email = data[0];
    var password = data[1];
    String endpointUrl = "https://itorrentseedrapi.herokuapp.com/magnetLink/";
    Map<String, String> queryParams = {'e': email, 'p': password, 'link': l};
    String queryString = Uri(queryParameters: queryParams).query;
    final requestUrl = endpointUrl + '?' + queryString;
    print("biswajit:$requestUrl");
    var res = await http.get(Uri.parse(requestUrl));
    var result = json.decode(res.body);

    var statuseCode = result['result'];

    print(result);
    if (result['result'] == true) {
      print('add Successfully');
    } else {
      print(result['result']);
    }
    return statuseCode;
  }

  Future getSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var password = prefs.getString('password');
    return [email, password];
  }
}
