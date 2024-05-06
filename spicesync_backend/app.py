from flask import Flask, jsonify, request
from scraping import scrape_and_update_database
from db import connect_to_mysql
import db_config
import user
app = Flask(__name__)

# Database connection details
HOST = db_config.HOST
USER = db_config.USER
PORT = db_config.PORT
PASSWORD = db_config.PASSWORD
DATABASE = db_config.DATABASE



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


# # Route to get recipes by category
# @app.route('/recipes/category/<string:category>', methods=['GET'])
# def get_recipes_by_category(category):
#     # Logic to retrieve recipes by category
#     return jsonify({'category': category, 'recipes': recipes})

# # Route to get latest recipes
# @app.route('/recipes/latest', methods=['GET'])
# def get_latest_recipes():
#     # Logic to retrieve latest recipes
#     return jsonify({'recipes': recipes})

# # Route to search recipes by name
# @app.route('/recipes/search', methods=['GET'])
# def search_recipes():
#     query = request.args.get('q')
#     # Logic to search recipes by name
#     return jsonify({'query': query, 'recipes': recipes})

# Route to scrape recipes
@app.route('/scrape', methods=['POST'])
def scrape_recipes():
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    scrape_and_update_database(connection)
    connection.close()
    # Logic to scrape recipes
    return jsonify({'message': 'Recipes scraped successfully'})


# Route to get ingredient list of a recipe
@app.route('/recipes/<int:recipe_id>/ingredients', methods=['GET'])
def get_ingredient_list(recipe_id):
    # Logic to retrieve ingredient list of a recipe
    return jsonify({'recipe_id': recipe_id, 'ingredients': []})

# Route to update ingredient list of a recipe
@app.route('/recipes/<int:recipe_id>/ingredients', methods=['PUT'])
def update_ingredient_list(recipe_id):
    # Logic to update ingredient list of a recipe
    return jsonify({'message': 'Ingredient list updated successfully'})

# Route to mark recipe as read
@app.route('/recipes/<int:recipe_id>/read', methods=['POST'])
def mark_recipe_as_read(recipe_id):
    # Logic to mark recipe as read
    return jsonify({'message': 'Recipe marked as read successfully'})

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
