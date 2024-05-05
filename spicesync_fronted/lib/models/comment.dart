import 'package:mysql_client/mysql_client.dart';

class Comment {
  final int commentId;
  final String commentText;
  final int userId;
  final int recipeId;

  Comment({
    required this.commentId,
    required this.commentText,
    required this.userId,
    required this.recipeId,
  });

  factory Comment.fromQueryResult(ResultSetRow row) {
    return Comment(
      commentId: int.parse(row.colByName('comment_id') as String),
      commentText: row.colByName('comment_text') as String,
      userId: int.parse(row.colByName('user_id') as String),
      recipeId: int.parse(row.colByName('recipe_id') as String),
    );
  }
}