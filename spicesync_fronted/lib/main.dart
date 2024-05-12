import 'package:flutter/material.dart';
import 'package:spicesync_fronted_test/screens/home.dart';
import '/screens/routes.dart';
import '/screens/welcome.dart';
import '/config/colors.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceSync',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18.0, color: AppColors.textColor),
          bodyText2: TextStyle(fontSize: 16.0, color: AppColors.textColor),
        )
      ),
      home: HomeScreen(), // Set the initial route
      onGenerateRoute: Routes.generateRoute,
    );
  }
}