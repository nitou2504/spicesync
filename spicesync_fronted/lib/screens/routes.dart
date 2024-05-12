// routes.dart
import 'package:flutter/material.dart';
import '/screens/welcome.dart';
import '/screens/home.dart';
import '/screens/login.dart';
import '/screens/register.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';

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
      default:
        return MaterialPageRoute(builder: (context) => HomeScreen()); // Fallback route
    }
  }
}