
import 'models/tags.dart'; // Adjust the import path to where your Tags class is located
import 'models/recipe.dart';
void main() async {
  List<Recipe> recipes = await Recipe.loadRecipesByName('Bread');

  recipes[0].printRecipe();
  
}