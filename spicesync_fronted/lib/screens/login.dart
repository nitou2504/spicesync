import 'package:flutter/material.dart';
import '/config/colors.dart'; // Import your color configuration
import '/screens/routes.dart'; // Import your routes configuration
import '/models/user.dart'; // Import the User model

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textColor),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Please enter your account here.',
                      style: TextStyle(fontSize: 20, color: AppColors.textColor),
                    ),
                    SizedBox(height: 10.0),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
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
                      controller: _passwordController,
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
                      ),
                      obscureText: true, // To hide the password
                    ),
                    SizedBox(height: 10.0),
                    
                    // Login button
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          var email = _emailController.text; // Use the text from the email TextFormField
                          var password = _passwordController.text; // Use the text from the password TextFormField
                          User user = await User.login(email, password); // Assuming email and password are defined
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Login Successful'),
                                content: Text('Welcome back, ${user.username}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                      Navigator.pushReplacementNamed(context, '/home'); // Navigate to the home screen
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Login Failed'),
                                content: Text('Failed to log in. Please try again.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor),
                    ),
                    SizedBox(height: 10.0),
                    
                    // Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        // Handle sign up logic here
                      },
                      child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
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