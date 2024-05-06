-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS spicesync;

-- Switch to the spicesync database
USE spicesync;

-- Table for users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for recipes
CREATE TABLE IF NOT EXISTS recipes (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL, -- Name is unique
    prep_time VARCHAR(255), -- As a string
    cook_time VARCHAR(255), -- As a string
    servings VARCHAR(255), -- As a string
    ingredients_list TEXT, -- Store ingredients as JSON array or string
    method_parts TEXT, -- Store method parts as JSON
    image_url VARCHAR(255), -- URL of the recipe image
    source_url VARCHAR(255) UNIQUE NOT NULL, -- URL of the recipe
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for tags
CREATE TABLE IF NOT EXISTS tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table to establish many-to-many relationship between recipes and tags
CREATE TABLE IF NOT EXISTS recipe_tags (
    recipe_id INT,
    tag_id INT,
    PRIMARY KEY (recipe_id, tag_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- Table for comments
CREATE TABLE IF NOT EXISTS comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_text TEXT,
    user_id INT,
    recipe_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);


-- Create the new recipe_read_history table
CREATE TABLE IF NOT EXISTS recipe_read_history (
    user_id INT,
    recipe_id INT,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    read_count INT DEFAULT 1,
    PRIMARY KEY (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

CREATE TABLE IF NOT EXISTS user_favorites (
    user_id INT,
    recipe_id INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);