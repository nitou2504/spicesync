import 'package:http_parser/http_parser.dart';

class Comment {
  final int commentId;
  final String commentText;
  final int userId;
  final int recipeId;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.commentText,
    required this.userId,
    required this.recipeId,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      commentText: json['comment_text'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      createdAt: parseHttpDate(json['created_at']),
    );
  }
}