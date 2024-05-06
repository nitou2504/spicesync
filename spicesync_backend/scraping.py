from bs4 import BeautifulSoup
import requests
import json
import os
from db import *
import db_config
from utils import *

######################## Extract recipe info

def extract_name(soup):
    return soup.find('h1').text.strip()

def extract_ingredients(soup):
    ingredients_list = soup.find('h2', id='ingredients').find_next('ul').find_all('li')
    ingredients = [ingredient.text.strip().replace('\n', ' ').replace('\t', ' ') for ingredient in ingredients_list]
    return ingredients

def extract_method_parts(soup):
    directions_heading = soup.find('h2', id='directions')
    method_parts = []
    if directions_heading:
        siblings = directions_heading.find_next_siblings()
        current_part_name = None
        for sibling in siblings:
            if sibling.name == 'p':
                current_part_name = sibling.text.strip().replace('\n', ' ').replace('\t', ' ').replace('\u00b0', ' deg. ')
            elif sibling.name == 'ol':
                steps = [step.text.strip().replace('\n', ' ').replace('\t', ' ').replace('\u00b0', ' deg. ') for step in sibling.find_all('li')]
                method_parts.append((current_part_name or '', steps))
    return method_parts


def extract_method_parts_with_paragraph(sibling):
    method_parts = []
    current_part_name = sibling.text.strip().replace('\n', ' ').replace('\t', ' ').replace('\u00b0', ' deg. ')
    steps = sibling.find_next('ol').find_all('li')
    method_steps = [step.text.strip().replace('\n', ' ').replace('\t', ' ').replace('\u00b0', ' deg. ') for step in steps]
    method_parts.append((current_part_name, method_steps))
    return method_parts


def extract_recipe_details(soup):
    details_list = soup.find('article').find('ul')
    details = details_list.find_all('li')
    prep_time = cook_time = servings = None
    for detail in details:
        text = detail.text.strip()
        if 'Prep time:' in text:
                prep_time = text.split(':')[-1].strip()
        elif 'Cook time:' in text:
            cook_time = text.split(':')[-1].strip()
        elif 'Servings:' in text:
            servings = text.split(':')[-1].strip()
    return prep_time, cook_time, servings

def extract_tags(soup):
    taglist_div = soup.find('div', class_='taglist')
    if taglist_div:
        tag_links = taglist_div.find_all('a', id=lambda x: x and x.startswith('tag_'))
        tag_names = [link.text.strip() for link in tag_links]
        return tag_names
    else:
        return []

def extract_image_url(soup):
    img_tag = soup.find('img', src=True)  # Find the first img tag with a src attribute
    if img_tag:
        if 'logo' in img_tag['alt'].lower():
            return None
        src = img_tag['src']  # Extract the value of the src attribute
        if src.startswith('/pix/'):
            return f"https://based.cooking{src}"  # Construct the absolute URL
    return None

# Function to extract recipe information
def extract_recipe_info(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    name = extract_name(soup)
    ingredients = extract_ingredients(soup)
    method_parts = extract_method_parts(soup)
    prep_time, cook_time, servings = extract_recipe_details(soup)
    tags = extract_tags(soup)
    image_url = extract_image_url(soup)

    # Add 'With image' tag if image_url is not None
    if image_url:
        tags.append('With Image')

    recipe_info = {
        'name': name,
        'ingredients': json.dumps(ingredients),  # Serialize ingredients to JSON
        'method_parts': json.dumps(method_parts),  # Serialize method_parts to JSON
        'prep_time': prep_time,
        'cook_time': cook_time,
        'servings': servings,
        'tags': json.dumps(tags),  # Serialize tags to JSON
        'image_url': image_url
    }
    return recipe_info


def print_recipe_info(recipe_info):
    print("Name:", recipe_info['name'])
    print("Ingredients:")
    for ingredient in recipe_info['ingredients']:
        print("-", ingredient)
    print("Method:")
    for part in recipe_info['method_parts']:
        part_name, part_steps = part
        print(f"Part: {part_name}")
        for step in part_steps:
            print("-", step)
    print("Preparation Time:", recipe_info['prep_time'])
    print("Cook Time:", recipe_info['cook_time'])
    print("Servings:", recipe_info['servings'])
    print("Tags:", recipe_info['tags'])


# Parse the site for all recipes
def extract_recipe_links(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    recipe_links = []
    ul_block = soup.find('ul', id='artlist')
    if ul_block:
        li_items = ul_block.find_all('li')
        for li in li_items:
            link = li.find('a')
            if link:
                href = link.get('href')
                name = link.text.strip()
                recipe_links.append((name, href))
    return recipe_links

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


# Function to load existing links from a file
def load_links_from_file(file_path):
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            return file.read().splitlines()
    else:
        return []

# Function to append new links to a file
def append_links_to_file(file_path, links):
    with open(file_path, 'a') as file:
        for link in links:
            file.write(f"{link}\n")


# Function to update the database with new recipes
def update_database(connection, recipes):
    for _, link in recipes:
        url_request = requests.get(link)
        html_content = url_request.content.decode('utf-8')
        recipe_info = extract_recipe_info(html_content)
        recipe_info['source_url'] = link
        insert_recipe(connection, recipe_info)

# Function to scrape the site and update the database
def scrape_and_update_database(connection, use_existing_links=False):
    # Extract recipe links
    BASE_URL = 'https://based.cooking/'
    url_request = requests.get(BASE_URL)
    html_content = url_request.content.decode('utf-8')
    recipes = extract_recipe_links(html_content)

    file_path = generate_local_path('links.txt')
    existing_links = load_links_from_file(file_path)
    
    # Filter out existing links
    new_recipes = [(name, link) for name, link in recipes if link not in existing_links]

    # In case we want to use existing links
    if use_existing_links:
        new_recipes = recipes

    # Update the database with new recipes
    update_database(connection, new_recipes)
    append_links_to_file(file_path, [link for name, link in new_recipes])



if __name__ == "__main__":


    HOST = db_config.HOST
    USER = db_config.USER
    PORT = db_config.PORT
    PASSWORD = db_config.PASSWORD
    DATABASE = db_config.DATABASE

    # Connect to MySQL database
    connection = connect_to_mysql(HOST, USER, PASSWORD, DATABASE)
    scrape_and_update_database(connection)
    connection.close()