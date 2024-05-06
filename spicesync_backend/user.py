import mysql.connector

def create_user(connection, user_json):
    try:
        cursor = connection.cursor()

        # Check if user already exists
        query = "SELECT user_id FROM users WHERE email = %s"
        cursor.execute(query, (user_json['email'],))
        existing_user = cursor.fetchone()

        if existing_user:
            print("User already exists")
            return None
        else:
            # Insert user into the users table
            query = """
                INSERT INTO users (email, username, phone_number, password)
                VALUES (%s, %s, %s, %s)
                """
            values = (
                user_json['email'],
                user_json['username'],
                user_json['phone_number'],
                user_json['password']
            )
            cursor.execute(query, values)
            connection.commit()
            print(f"User {user_json['email']} inserted successfully")
            return user_json

    except mysql.connector.Error as e:
        print(f"Error inserting user into database: {e}")
        return None
    finally:
        if connection.is_connected():
            cursor.close()

def login_user(connection, login_credentials):
    try:
        cursor = connection.cursor()

        # Check if user exists with provided email and password
        query = "SELECT user_id FROM users WHERE email = %s AND password = %s"
        cursor.execute(query, (login_credentials['email'], login_credentials['password']))
        user = cursor.fetchone()

        if user:
            print("Login successful")
            return user[0]  # Return user_id
        else:
            print("Invalid email or password")
            return None

    except mysql.connector.Error as e:
        print(f"Error during login: {e}")
        return None
    finally:
        if connection.is_connected():
            cursor.close()