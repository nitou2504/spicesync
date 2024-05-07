def get_recipes_per_tag(connection, tag, batch_size=15, offset=0):
    cursor = connection.cursor(dictionary=True)

    # Fetch recipes for a specific tag with pagination
    cursor.execute("SELECT r.* FROM recipes r JOIN recipe_tags rt ON r.recipe_id = rt.recipe_id JOIN tags t ON rt.tag_id = t.tag_id WHERE t.tag_name = %s LIMIT %s OFFSET %s", (tag, batch_size, offset))
    recipes = cursor.fetchall()

    cursor.close()
    return recipes

def get_recipes_tags(connection):
    cursor = connection.cursor(dictionary=True)

    # Fetch all unique tag names from the tags table
    cursor.execute("SELECT tag_name FROM tags")
    tags = cursor.fetchall()

    cursor.close()
    return tags

def get_latest_recipes(connection, batch_size=15, offset=0):
    cursor = connection.cursor(dictionary=True)

    # Fetch latest recipes with pagination
    cursor.execute("SELECT * FROM recipes ORDER BY created_at DESC LIMIT %s OFFSET %s", (batch_size, offset))
    latest_recipes = cursor.fetchall()

    cursor.close()
    return latest_recipes

def search_recipes_by_name(connection, name, batch_size=15, offset=0):
    cursor = connection.cursor(dictionary=True)

    # Fetch recipes matching the name with pagination support
    cursor.execute("SELECT * FROM recipes WHERE name LIKE %s LIMIT %s OFFSET %s", ('%' + name + '%', batch_size, offset))
    recipes = cursor.fetchall()

    cursor.close()
    return recipes

def get_favorite_recipes(connection, user_id, batch_size=15, offset=0):
    cursor = connection.cursor(dictionary=True)

    # Fetch favorite recipes for a specific user with pagination support
    cursor.execute("SELECT r.* FROM recipes r JOIN user_favorites uf ON r.recipe_id = uf.recipe_id WHERE uf.user_id = %s LIMIT %s OFFSET %s", (user_id, batch_size, offset))
    favorite_recipes = cursor.fetchall()

    cursor.close()
    return favorite_recipes

def add_recipe_to_favorites(connection, user_id, recipe_id):
    cursor = connection.cursor()

    # Check if the recipe is already in user favorites
    cursor.execute("SELECT * FROM user_favorites WHERE user_id = %s AND recipe_id = %s", (user_id, recipe_id))
    existing_favorite = cursor.fetchone()

    if existing_favorite:
        # Recipe already exists in favorites
        return False
    else:
        # Add the recipe to user favorites
        cursor.execute("INSERT INTO user_favorites (user_id, recipe_id) VALUES (%s, %s)", (user_id, recipe_id))
        connection.commit()
        return True


def remove_recipe_from_favorites(connection, user_id, recipe_id):
    cursor = connection.cursor()

    # Check if the recipe is in user favorites
    cursor.execute("SELECT * FROM user_favorites WHERE user_id = %s AND recipe_id = %s", (user_id, recipe_id))
    existing_favorite = cursor.fetchone()

    if existing_favorite:
        # Remove the recipe from user favorites
        cursor.execute("DELETE FROM user_favorites WHERE user_id = %s AND recipe_id = %s", (user_id, recipe_id))
        connection.commit()
        return True
    else:
        # Recipe not found in favorites
        return False

def get_read_recipes(connection, user_id, batch_size=15, offset=0):
    cursor = connection.cursor(dictionary=True)

    # Fetch read recipes for a specific user with pagination support
    cursor.execute("SELECT r.* FROM recipes r JOIN recipe_read_history rrh ON r.recipe_id = rrh.recipe_id WHERE rrh.user_id = %s ORDER BY rrh.last_accessed DESC LIMIT %s OFFSET %s", (user_id, batch_size, offset))
    read_recipes = cursor.fetchall()

    cursor.close()
    return read_recipes

def add_or_update_read_recipe(connection, user_id, recipe_id):
    # TODO: verify if the recipe_id exists in the recipes table

    cursor = connection.cursor()

    # Check if the recipe is already in the read history
    cursor.execute("SELECT * FROM recipe_read_history WHERE user_id = %s AND recipe_id = %s", (user_id, recipe_id))
    existing_read_recipe = cursor.fetchone()

    if existing_read_recipe:
        # If the recipe is already in the history, update the last_accessed timestamp and increment the read count
        cursor.execute("UPDATE recipe_read_history SET last_accessed = CURRENT_TIMESTAMP, read_count = read_count + 1 WHERE user_id = %s AND recipe_id = %s", (user_id, recipe_id))
    else:
        # If the recipe is not in the history, insert a new record
        cursor.execute("INSERT INTO recipe_read_history (user_id, recipe_id) VALUES (%s, %s)", (user_id, recipe_id))

    connection.commit()
    cursor.close()
