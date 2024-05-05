import 'package:mysql_client/mysql_client.dart';
import 'dart:convert';

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
}