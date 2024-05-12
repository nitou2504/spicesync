// routes.dart
import 'package:flutter/material.dart';
import '/screens/welcome.dart';
import '/screens/home.dart';
import '/screens/login.dart';
import '/screens/register.dart';
import '/screens/recipeCardScreen.dart';
import '/models/recipe.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String recipeCardScreen = '/recipeCardScreen'; // New route for RecipeCardScreen

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case recipeCardScreen: // New case for RecipeCardScreen
        return MaterialPageRoute(builder: (context) => RecipeCardScreen(recipe: settings.arguments as Recipe));
      default:
        return MaterialPageRoute(builder: (context) => HomeScreen()); // Fallback route
    }
  }
}