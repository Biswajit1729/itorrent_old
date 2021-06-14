import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    String endpointUrl =
        "https://hardcore-kilby-751fdb.netlify.app/.netlify/functions/api/magnetLink/";
    Map<String, String> queryParams = {'link': l};
    String queryString = Uri(queryParameters: queryParams).query;
    final requestUrl = endpointUrl + '?' + queryString;

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
}
