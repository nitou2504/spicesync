import mysql.connector
import json


def connect_to_mysql(host, user, password, database, port='3306'):
    try:
        connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database,
            port=port
        )
        print("Connected to MySQL database")
        return connection
    except mysql.connector.Error as e:
        print(f"Error connecting to MySQL database: {e}")
        return None
    

def insert_recipe(connection, recipe_info):
    try:
        cursor = connection.cursor()
        
        # Check if the recipe already exists in the database
        query = "SELECT recipe_id FROM recipes WHERE name = %s"
        cursor.execute(query, (recipe_info['name'],))
        existing_recipe = cursor.fetchone()
        
        if existing_recipe:
            print("Recipe already exists in the database")
            return
        else:
            # Insert the recipe into the recipes table
            query = """
                INSERT INTO recipes (name, ingredients_list, method_parts, prep_time, cook_time, servings, image_url, source_url)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            values = (
                recipe_info['name'],
                recipe_info['ingredients'],
                recipe_info['method_parts'],
                recipe_info['prep_time'],
                recipe_info['cook_time'],
                recipe_info['servings'],
                recipe_info['image_url'],
                recipe_info['source_url']
            )
            cursor.execute(query, values)
            connection.commit()
            print(f"Recipe {recipe_info['name']} inserted successfully")
            recipe_id = cursor.lastrowid

        # Insert tags into the tags table and associate them with the recipe in the recipe_tags table
        if 'tags' in recipe_info:
            tags = json.loads(recipe_info['tags'])
            for tag in tags:
                # Insert the tag if it doesn't exist
                query = "INSERT IGNORE INTO tags (tag_name) VALUES (%s)"
                cursor.execute(query, (tag,))
                connection.commit()

                # Get the tag_id
                query = "SELECT tag_id FROM tags WHERE tag_name = %s"
                cursor.execute(query, (tag,))
                tag_id = cursor.fetchone()[0]

                # Associate the tag with the recipe in the recipe_tags table
                query = "INSERT INTO recipe_tags (recipe_id, tag_id) VALUES (%s, %s)"
                cursor.execute(query, (recipe_id, tag_id))
                connection.commit()

            print("Tags inserted and associated successfully")
    except mysql.connector.Error as e:
        print(f"Error inserting recipe into database: {e}")
    finally:
        if connection.is_connected():
            cursor.close()