def get_recipe_comments(connection, recipe_id):
    cursor = connection.cursor(dictionary=True)

    # Fetch comments for a specific recipe
    cursor.execute("SELECT * FROM comments WHERE recipe_id = %s", (recipe_id,))
    comments = cursor.fetchall()

    cursor.close()
    return comments

def add_comment(connection, user_id, recipe_id, comment_text):
    cursor = connection.cursor()

    # Insert a new comment
    cursor.execute("INSERT INTO comments (comment_text, user_id, recipe_id) VALUES (%s, %s, %s)", (comment_text, user_id, recipe_id))
    connection.commit()

    cursor.close()


