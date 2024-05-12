import 'package:flutter/material.dart';
import '/screens/routes.dart';
import '/screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(), // Set the initial route
      onGenerateRoute: Routes.generateRoute,
    );
  }
}