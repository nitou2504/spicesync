// Import the recipe.dart file
import '/models/recipe.dart';

Future<void> main() async {

  // Load the latest recipes
  List<Recipe> latestRecipes = await Recipe.loadLatestRecipes(offset: 0, batch_size: 5);

  // Print the name of each recipe
  for (var recipe in latestRecipes) {
    print(recipe.name);
  }

  List<Recipe> recipes1 = await Recipe.loadLatestRecipes(offset: 5, batch_size: 5);

  // Print the name of each recipe
  for (var recipe in recipes1) {
    print(recipe.name);
  }
}