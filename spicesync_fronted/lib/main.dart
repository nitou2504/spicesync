import 'package:flutter/material.dart';
import 'package:spicesync_fronted_test/screens/home.dart';
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
      home: HomeScreen(), // Set the initial route
      onGenerateRoute: Routes.generateRoute,
    );
  }
}