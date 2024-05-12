// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '/config/colors.dart'; // Import your color configuration
import '/screens/routes.dart'; // Import your routes configuration

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white.withOpacity(0.95),
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Welcome message
                    Text(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textColor), // Updated color
                    ),

                    SizedBox(height: 10.0), // Increased space
                    Text(
                      'Please enter your account here.',
                      style: TextStyle(fontSize: 20, color: AppColors.textColor), // Updated color
                    ),

                    SizedBox(height: 10.0), // Increased space

                    // Email field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: AppColors.textColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    // Password field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: AppColors.textColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        // obscureText: true,
                      ),
                    ),
                    SizedBox(height: 10.0),

                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)), // Adjusted text size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.0),

                    // Or text above Sign Up button
                    Text(
                      'or',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor), // Updated color
                    ),
                    SizedBox(height: 10.0),

                    // Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        // Handle sign up logic here
                      },
                      child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)), // Adjusted text size
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),

                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}