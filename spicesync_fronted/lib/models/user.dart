import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/api.dart' as api; // Import the Api class

class User {
  final int userId;
  final String email;
  final String username;
  final String phoneNumber;
  String password;

  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.phoneNumber,
    this.password = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phone_number'],
    );
  }

  // login
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${api.apiBaseUrlEmulator}/login'), // Use the emulator base URL from the Api class
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON to get the user_id.
      int userId = jsonDecode(response.body)['user_id'];
      // Fetch the user's profile details using the user_id.
      final userProfileResponse = await http.get(Uri.parse('${api.apiBaseUrlEmulator}/user_profile/$userId'));
      if (userProfileResponse.statusCode == 200) {
        // Parse the JSON to create a User object.
        return User.fromJson(jsonDecode(userProfileResponse.body));
      } else {
        // Handle error when fetching user profile.
        throw Exception('Failed to fetch user profile');
      }
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to log in');
    }
  }
}