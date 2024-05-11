import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import '/config/api.dart' as api;

Future<void> main() async {
  var emulator = true;
  var url = '';

  if (emulator){
    url = '${api.apiBaseUrlEmulator}/user_profile/1'; // Assuming user_id is 1 for testing
  } else {
    url = '${api.apiBaseUrl}/user_profile/1'; // Assuming user_id is 1 for testing
  }

  // Make a GET request to the get_user_profile_route
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    var userProfileJson = jsonDecode(response.body);
    var user = User.fromJson(userProfileJson);

    // Print the details of the user
    print('User ID: ${user.userId}');
    print('Email: ${user.email}');
    print('Username: ${user.username}');
    print('Phone Number: ${user.phoneNumber}');
    print('---');
  } else {
    // If the server returns an error response, throw an exception.
    throw Exception('Failed to load user profile');
  }
}