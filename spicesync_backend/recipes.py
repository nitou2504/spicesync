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
