import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/api.dart' as api;

class Tags {
  static Future<List<String>> getTagNames() async {
    final response = await http.get(Uri.parse('${api.apiBaseUrlEmulator}/tags'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON and return the list of tag names
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<String> tags = [];

      for (var map in jsonResponse) {
        var tag = map['tag_name'];
        tags.add(tag);
      }
      return tags;
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to load tags from server');
    }
  }
}