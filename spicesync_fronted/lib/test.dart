import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/comment.dart';
import '/config/api.dart' as api;

Future<void> main() async {
  var emulator = true;
  var url = '';

  if (emulator){
    url = '${api.apiBaseUrlEmulator}/recipes/1/comments'; // Assuming recipe_id is 1 for testing
  } else {
    url = '${api.apiBaseUrl}/recipes/1/comments'; // Assuming recipe_id is 1 for testing
  }

  // Make a GET request to the get_recipe_comments_route
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    var commentsJson = jsonDecode(response.body);
    var comments = commentsJson.map((commentJson) => Comment.fromJson(commentJson)).toList();

    // Print the details of each comment
    for (var comment in comments) {
      print('Comment ID: ${comment.commentId}');
      print('Comment Text: ${comment.commentText}');
      print('User ID: ${comment.userId}');
      print('Recipe ID: ${comment.recipeId}');
      print('---');
    }
  } else {
    // If the server returns an error response, throw an exception.
    throw Exception('Failed to load comments for the recipe');
  }
}