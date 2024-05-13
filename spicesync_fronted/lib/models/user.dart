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

  // register
    static Future<User> register(String email, String username, String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('${api.apiBaseUrlEmulator}/register'), // Use the emulator base URL from the Api class
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Assuming the backend returns the user_id in the response body
      var userId = jsonDecode(response.body)['user_id'];
      return User(userId: userId, email: email, username: username, phoneNumber: phoneNumber, password: password);
    } else {
      throw Exception('Failed to register');
    }
  }

  //method to add user favorite recipe
  static Future<bool> addFavoriteRecipe(int userId, int recipeId) async {
    final response = await http.post(
      Uri.parse('${api.apiBaseUrlEmulator}/users/$userId/favorite_recipes/add?recipe_id=$recipeId'));

    // return true if the recipe was added successfully
    if (response.statusCode == 201) {
      return true;
    }
    // return true if the recipe was already added
    if (response.statusCode == 409) {
      return true;
    }

    if (response.statusCode == 400) {
      throw Exception('Failed to add favorite recipe');
    }

    // Add a return statement at the end to fix the issue
    return false;
  }

  //method to remove user favorite recipe
  static Future<void> removeFavoriteRecipe(int userId, int recipeId) async {
    final response = await http.post(
      Uri.parse('${api.apiBaseUrlEmulator}/users/$userId/favorite_recipes/remove?recipe_id=$recipeId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite recipe');
    }
  }

}