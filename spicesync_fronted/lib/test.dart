import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/recipe.dart';
import '/config/api.dart' as api;

Future<void> main() async {

  var emulator = true;
  var url = '';

  if (emulator){
    url = '${api.apiBaseUrlEmulator}/latest_recipes?batch_size=1';
  // ignore: dead_code
  } else {
    url = '${api.apiBaseUrl}/latest_recipes?batch_size=1';
  }

  // Make a GET request to the latest_recipes_route
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    var latestRecipes = jsonDecode(response.body);
    // print(latestRecipes); // Print the list of latest recipes

    var recipe = latestRecipes[0];
    var recipeObject = Recipe.fromJson(recipe);
    await recipeObject.fetchAndSetTags();
    recipeObject.printRecipe();

    // Close the database connection
  } else {
    // If the server returns an error response, throw an exception.
    throw Exception('Failed to load latest recipes');
  }
}
