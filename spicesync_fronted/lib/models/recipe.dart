import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '/config/api.dart' as api;

class Recipe {
  final int id;
  final String name;
  final String? prepTime;
  final String? cookTime;
  final String? servings;
  final List<dynamic> ingredientsList;
  final List<dynamic> methodParts;
  final String? imageUrl;
  final String? sourceUrl;
  final DateTime createdAt;
  List<String> tags;

  Recipe({
    required this.id,
    required this.name,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.ingredientsList,
    required this.methodParts,
    required this.imageUrl,
    required this.sourceUrl,
    required this.createdAt,
    this.tags = const [],
  });

  factory Recipe.fromJson(Map jsonMap) {

    print(jsonMap['created_at'].runtimeType);
    print(jsonMap['created_at']);


    return Recipe(
      id: jsonMap['recipe_id'],
      name: jsonMap['name'] as String,
      prepTime: jsonMap['prep_time'] as String?,
      cookTime: jsonMap['cook_time'] as String?,
      servings: jsonMap['servings'] as String?,
      ingredientsList: jsonDecode(jsonMap['ingredients_list']),
      methodParts: jsonDecode(jsonMap['method_parts']),
      imageUrl: jsonMap['image_url'] as String?,
      sourceUrl: jsonMap['source_url'] as String?,
      createdAt: parseHttpDate(jsonMap['created_at']),
    );
  }
  
  factory Recipe.fromQueryResult(ResultSetRow row) {
    return Recipe(
      id: int.parse( row.colByName('recipe_id') as String),
      name: row.colByName('name') as String,
      prepTime: row.colByName('prep_time') as String,
      cookTime: row.colByName('cook_time') as String,
      servings: row.colByName('servings') as String,
      ingredientsList: jsonDecode(row.colByName('ingredients_list') as String),
      methodParts: jsonDecode(row.colByName('method_parts') as String),
      imageUrl: row.colByName('image_url') as String?,
      sourceUrl: row.colByName('source_url') as String,
      createdAt: DateTime.parse(row.colByName('created_at') as String),
    );
  }

  // Methods

  void printRecipe() {
    print('Recipe ID: $id');
    print('Name: $name');
    print('Preparation Time: $prepTime');
    print('Cooking Time: $cookTime');
    print('Servings: $servings');
    print('Ingredients List: $ingredientsList');
    print('Method Parts: $methodParts');
    print('Image URL: $imageUrl');
    print('Source URL: $sourceUrl');
    print('Created At: $createdAt');
    print('Tags: $tags');
  }

  Future<List<String>> fetchRecipeTags(int recipeId) async {
  final response = await http.get(Uri.parse('${api.apiBaseUrlEmulator}/recipes/$recipeId/tags'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the tags from the response body.
    List<dynamic> responseBody = jsonDecode(response.body);
    return responseBody.map((tag) => tag['tag_name'] as String).toList();
  } else {
    // If the server returns an unexpected response, throw an exception.
    throw Exception('Failed to load recipe tags');
  }
  }

  Future<void> fetchAndSetTags() async {
    this.tags = await fetchRecipeTags(this.id);
  }

}
