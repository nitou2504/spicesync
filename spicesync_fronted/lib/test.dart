import 'models/user.dart';
import 'models/tags.dart'; // Adjust the import path to where your Tags class is located
import 'models/recipe.dart';
void main() async {
  User.removeFavoriteRecipe(1, 43);
  List<Recipe> recipes = await Recipe.loadFavoriteRecipes(1);



  recipes[0].printRecipe();
  
}