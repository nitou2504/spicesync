import 'package:flutter/material.dart';
import '/config/colors.dart'; // Assuming you have a file for your color configurations

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white, // Ensure the card color is also white
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your logo or title here
                Text(
                  'SpiceSync',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor, // Assuming you have a secondary color
                  ),
                ),
                SizedBox(height: 20.0), // Space between the title and the email field

                // Email field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.textColor), // Assuming you have a text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.0), // Space between the email field and the password field

                // Password field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.textColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0), // Space between the password field and the login button

                // Login button
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic here
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor, // Assuming you have a secondary color
                    // onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}