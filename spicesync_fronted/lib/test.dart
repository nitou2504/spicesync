import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import '/config/api.dart' as api;

Future<void> main() async {
  var emulator = true;
  var url = '';

// test data
var email = 'h@s.com';
var username = 'h';
var phoneNumber = '1234567890';
var password = 'password';

User user = await User.register(email, username, phoneNumber, password);

print(user.userId);
}