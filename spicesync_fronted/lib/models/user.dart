import 'package:mysql_client/mysql_client.dart';

class User {
  final int userId;
  final String email;
  final String? phoneNumber;
  final String password; // this is not gonna be a plain text password in a real-world application
  final DateTime createdAt;

  User({
    required this.userId,
    required this.email,
    this.phoneNumber,
    required this.password,
    required this.createdAt,
  });

  factory User.fromQueryResult(ResultSetRow row) {
    return User(
      userId: int.parse(row.colByName('user_id') as String),
      email: row.colByName('email') as String,
      phoneNumber: row.colByName('phone_number') as String?,
      password: row.colByName('password') as String,
      createdAt: DateTime.parse(row.colByName('created_at') as String),
    );
  }
}