import '/models/recipe.dart';
import '/models/user.dart';
import '/models/comment.dart';
import '/config/db_config.dart';

Future<void> main() async {

  final conn = await DbConfig.getConnection();


  // Sample recipe
  final result = await conn.execute("SELECT *  FROM recipes WHERE recipe_id = 1;");

  final List<Recipe> recipes = [];
  
  for (final row in result.rows) {
    recipes.add(Recipe.fromQueryResult(row));
  }

  for (final recipe in recipes) {
    print('******************');
    print('Recipe ID: ${recipe.id}');
    print('Name: ${recipe.name}');
    print('Prep Time: ${recipe.prepTime}');
    print('Cook Time: ${recipe.cookTime}');
    print('Servings: ${recipe.servings}');
    print('Ingredients List: ${recipe.ingredientsList}');
    print('Method Parts: ${recipe.methodParts}');
    print('Image URL: ${recipe.imageUrl}');
    print('Source URL: ${recipe.sourceUrl}');
    print('Created At: ${recipe.createdAt}');
  }

  // Sample user
  final userResult = await conn.execute("SELECT *  FROM users WHERE user_id = 1;");

  final List<User> users = [];

  for (final row in userResult.rows) {
    users.add(User.fromQueryResult(row));
  }

  for (final user in users) {
    print('******************');
    print('User ID: ${user.userId}');
    print('Email: ${user.email}');
    print('Phone Number: ${user.phoneNumber}');
    print('Password: ${user.password}');
    print('Created At: ${user.createdAt}');
  }

  // Sample comment
  final commentResult = await conn.execute("SELECT *  FROM comments WHERE comment_id = 1;");

  final List<Comment> comments = [];

  for (final row in commentResult.rows) {
    comments.add(Comment.fromQueryResult(row));
  }

  for (final comment in comments) {
    print('******************');
    print('Comment ID: ${comment.commentId}');
    print('Comment Text: ${comment.commentText}');
    print('User ID: ${comment.userId}');
    print('Recipe ID: ${comment.recipeId}');
  }




  await conn.close();
}
