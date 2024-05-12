import 'package:flutter/material.dart';
import 'package:spicesync_fronted_test/config/colors.dart';
import '/models/recipe.dart'; // Adjust the import path as necessary
import '/screens/recipeCard.dart'; // Adjust the import path as necessary

Future<void> main() async {
  // Load the latest recipes
  List<Recipe> latestRecipes = await Recipe.loadLatestRecipes(offset: 0, batch_size: 5);

  // Check if there are any recipes loaded
  if (latestRecipes.isNotEmpty) {
    // Select the first recipe from the list
    Recipe firstRecipe = latestRecipes.first;

    // Print the name of the first recipe
    print(firstRecipe.name);

    // Create a test program to display the first RecipeCard
    runApp(TestApp(firstRecipe: firstRecipe));
  } else {
    print("No recipes loaded.");
  }
}

class TestApp extends StatelessWidget {
  final Recipe firstRecipe;

  TestApp({required this.firstRecipe});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18.0, color: AppColors.textColor),
          bodyText2: TextStyle(fontSize: 16.0, color: AppColors.textColor),
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('${firstRecipe.name}'),
        ),
        body: Center(
          child: RecipeCard(recipe: firstRecipe),
        ),
      ),
    );
  }
}