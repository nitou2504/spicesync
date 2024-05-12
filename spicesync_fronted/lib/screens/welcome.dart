// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '/config/colors.dart';
import '/screens/routes.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/welcome.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0, // Align the card to the bottom
              left: 0, // Align the card to the left
              right: 0, // Align the card to the right
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Content doesn't overflow
                    children: [
                      Text(
                        'SpiceSync',
                        style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 50.0), // Add some space between title and description
                      Padding(
                        padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                        child: Text(
                          'SpiceSync is a platform that allows you to read simple recipes 🥗 🥞 from all over the World 🗺️. \nOnly recipes, no distractions ⚡',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0, color: AppColors.textColor), 
                        ),
                      ),
                      SizedBox(height: 50.0), // Space before button
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: Text('Get Started', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        )
                      ),
                      SizedBox(height: 10.0), // Space after button
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}