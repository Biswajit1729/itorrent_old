import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getSuggestion(String pattern) async {
  String endpointUrl = "https://suggestqueries.google.com/complete/search";
  Map<String, String> queryParams = {
    'client': "chrome",
    'hl': "en",
    "q": pattern
  };
  String queryString = Uri(queryParameters: queryParams).query;
  final requestUrl = endpointUrl + '?' + queryString;

  var res = await http.get(Uri.encodeFull(requestUrl), headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, HEAD",
    'content-type': 'application/json; charset=UTF-8',
    'Accept': '*/*',
    'Connection': 'keep-alive',
  });
  List link = jsonDecode(res.body)[1];
  return link;
}
