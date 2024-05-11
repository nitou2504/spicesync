import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/recipe.dart';

// host localhost
const emulator_local_host = '10.0.2.2';
const host_local_host = 'localhost';

Future<void> main() async {

  var emulator = true;
  var url = '';

  if (emulator){
    url = 'http://$emulator_local_host:2525/latest_recipes?batch_size=1';
  // ignore: dead_code
  } else {
    url = 'http://$host_local_host:2525/latest_recipes?batch_size=1';
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
