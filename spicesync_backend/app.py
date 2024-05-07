from flask import Flask, jsonify, request
from scraping import scrape_and_update_database
from db import connect_to_mysql
import db_config
import user, recipes
app = Flask(__name__)

# Database connection details
HOST = db_config.HOST
USER = db_config.USER
PORT = db_config.PORT
PASSWORD = db_config.PASSWORD
DATABASE = db_config.DATABASE


###### Users ######

# Route to register a new user
@app.route('/register', methods=['POST'])
def register_user():
    # Logic to register a new user
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    user_json = request.get_json()
    user_ = user.create_user(connection, user_json)
    connection.close()
    if user_ is None:
        return jsonify({"message": "User already exists"}), 400
    else:
        return jsonify({"message": "User created successfully"}), 201

    
# Route to log in
@app.route('/login', methods=['POST'])
def login_user():
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)  # Establish MySQL connection
    login_credentials = request.get_json()  # Get login credentials from request

    # Call the login_user function from user module
    user_id = user.login_user(connection, login_credentials)

    connection.close()  # Close MySQL connection

    if user_id:
        return jsonify({"message": "Login successful", "user_id": user_id}), 200
    else:
        return jsonify({"message": "Invalid email or password"}), 401


# Route to update user profile
@app.route('/update_user/<int:user_id>', methods=['PUT'])
def update_user_route(user_id):
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    user_data = request.get_json()
    updated_user = user.update_user(connection, user_id, user_data)
    connection.close()

    if updated_user:
        return jsonify({"message": "User updated successfully", "user": updated_user}), 200
    else:
        return jsonify({"message": f"Failed to update user with ID {user_id}"}), 404


# Route to get user profile
@app.route('/user_profile/<int:user_id>', methods=['GET'])
def get_user_profile_route(user_id):
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    user_profile = user.get_user_profile(connection, user_id)
    connection.close()

    if user_profile:
        return jsonify(user_profile), 200
    else:
        return jsonify({"message": "User not found"}), 404
    
###### Recipes ######

@app.route('/recipes/<string:tag>', methods=['GET'])
def get_recipes_per_tag_route(tag):
    batch_size = request.args.get('batch_size', default=15, type=int)
    offset = request.args.get('offset', default=0, type=int)
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    recipes_list = recipes.get_recipes_per_tag(connection, tag, batch_size, offset)
    connection.close()

    if recipes_list:
        return jsonify(recipes_list), 200
    else:
        return jsonify({"message": "No recipes found for this tag"}), 404
    
@app.route('/tags', methods=['GET'])
def get_recipes_tags_route():
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    tags = recipes.get_recipes_tags(connection)
    connection.close()

    if tags:
        return jsonify(tags), 200
    else:
        return jsonify({"message": "No tags found"}), 404


@app.route('/latest_recipes', methods=['GET'])
def latest_recipes_route():
    batch_size = request.args.get('batch_size', default=15, type=int)
    offset = request.args.get('offset', default=0, type=int)

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)  
    latest_recipes = recipes.get_latest_recipes(connection, batch_size, offset)
    connection.close()

    if latest_recipes:
        return jsonify(latest_recipes), 200
    else:
        return jsonify({"message": "No recipes found"}), 404

@app.route('/recipes/search', methods=['GET'])
def search_recipes_by_name_route():
    name = request.args.get('name')
    batch_size = request.args.get('batch_size', default=15, type=int)
    offset = request.args.get('offset', default=0, type=int)

    if not name:
        return jsonify({"message": "Name parameter is required"}), 400

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    recipes_list = recipes.search_recipes_by_name(connection, name, batch_size, offset)
    connection.close()

    if recipes_list:
        return jsonify(recipes_list), 200
    else:
        return jsonify({"message": "No recipes_list found"}), 404

# Route to get user favorite recipes
@app.route('/users/<int:user_id>/favorite_recipes', methods=['GET'])
def get_favorite_recipes_route(user_id):
    batch_size = int(request.args.get('batch_size', 15))
    offset = int(request.args.get('offset', 0))

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    favorite_recipes = recipes.get_favorite_recipes(connection, user_id, batch_size, offset)
    connection.close()

    if favorite_recipes:
        return jsonify(favorite_recipes), 200
    else:
        return jsonify({"message": "No favorite recipes found for this user"}), 404

@app.route('/users/<int:user_id>/favorite_recipes/add', methods=['POST'])
def add_recipe_to_favorites_route(user_id):
    recipe_id = request.args.get('recipe_id')

    if not recipe_id:
        return jsonify({"message": "Recipe ID is missing"}), 400

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    added = recipes.add_recipe_to_favorites(connection, user_id, int(recipe_id))
    connection.close()

    if added:
        return jsonify({"message": "Recipe added to favorites"}), 201
    else:
        return jsonify({"message": "Recipe is already in favorites"}), 409


@app.route('/users/<int:user_id>/favorite_recipes/remove', methods=['POST'])
def remove_recipe_from_favorites_route(user_id):
    recipe_id = request.args.get('recipe_id')

    if not recipe_id:
        return jsonify({"message": "Recipe ID is missing"}), 400

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    removed = recipes.remove_recipe_from_favorites(connection, user_id, int(recipe_id))
    connection.close()

    if removed:
        return jsonify({"message": "Recipe removed from favorites"}), 200
    else:
        return jsonify({"message": "Recipe not found in favorites"}), 404

@app.route('/users/<int:user_id>/read_recipes', methods=['GET'])
def get_read_recipes_route(user_id):
    batch_size = int(request.args.get('batch_size', 15))
    offset = int(request.args.get('offset', 0))

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    read_recipes = recipes.get_read_recipes(connection, user_id, batch_size, offset)
    connection.close()

    if read_recipes:
        return jsonify(read_recipes), 200
    else:
        return jsonify({"message": "No read recipes found for this user"}), 404

@app.route('/users/<int:user_id>/read_recipes', methods=['POST'])
def add_or_update_read_recipe_route(user_id):
    recipe_id = request.args.get('recipe_id')

    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    recipes.add_or_update_read_recipe(connection, user_id, recipe_id)
    connection.close()

    return jsonify({"message": "Read recipe added/updated successfully"}), 200


# Route to scrape recipes
@app.route('/scrape', methods=['POST'])
def scrape_recipes():
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    scrape_and_update_database(connection)
    connection.close()
    # Logic to scrape recipes
    return jsonify({'message': 'Recipes scraped successfully'})


###### Comments ######

# Route to get comments on a recipe
@app.route('/recipes/<int:recipe_id>/comments', methods=['GET'])
def get_comments(recipe_id):
    # Logic to retrieve comments on a recipe
    return jsonify({'recipe_id': recipe_id, 'comments': []})

# Route to make a comment on a recipe
@app.route('/recipes/<int:recipe_id>/comments', methods=['POST'])
def make_comment(recipe_id):
    # Logic to make a comment on a recipe
    return jsonify({'message': 'Comment added successfully'})

if __name__ == '__main__':
    app.run(debug=True, port=2525) # Run the Flask api on port 2525
