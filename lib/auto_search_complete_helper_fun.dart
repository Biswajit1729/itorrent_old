import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getSustions(String pattern) async {
  String endpointUrl = "https://suggestqueries.google.com/complete/search";
  Map<String, String> queryParams = {
    'client': "firefox",
    'hl': "en",
    "q": pattern
  };
  String queryString = Uri(queryParameters: queryParams).query;
  final requestUrl = endpointUrl + '?' + queryString;

  var res = await http.get(Uri.encodeFull(requestUrl));
  List link = jsonDecode(res.body)[1];
  return link;
}