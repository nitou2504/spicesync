
class User {
  final int userId;
  final String email;
  final String username;
  final String phoneNumber;
  String password;

  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.phoneNumber,
    this.password = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phone_number'],
    );
  }
}