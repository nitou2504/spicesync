import 'package:flutter/material.dart';
import '/screens/recipeCard.dart';
import '/models/recipe.dart';

class RecipeCardScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Center(
        child: RecipeCard(recipe: recipe),
      ),
    );
  }
}