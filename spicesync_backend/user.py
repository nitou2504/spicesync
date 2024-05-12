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

            query = "SELECT user_id FROM users WHERE email = %s"
            cursor.execute(query, (user_json['email'],))
            user_json['user_id'] = cursor.fetchone()[0]
            print(f"User with ID {user_json['user_id']} created successfully")
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


def update_user(connection, user_id, user_data):
    try:
        cursor = connection.cursor(dictionary=True)

        # Check if user exists
        query = "SELECT * FROM users WHERE user_id = %s"
        cursor.execute(query, (user_id,))
        existing_user = cursor.fetchone()

        if existing_user:
            # Update user data
            query = """
                UPDATE users 
                SET email = %s, username = %s, phone_number = %s, password = %s 
                WHERE user_id = %s
                """
            values = (
                user_data.get('email', existing_user['email']),
                user_data.get('username', existing_user['username']),
                user_data.get('phone_number', existing_user['phone_number']),
                user_data.get('password', existing_user['password']),
                user_id
            )
            cursor.execute(query, values)
            connection.commit()
            print(f"User with ID {user_id} updated successfully")
            return user_data
        else:
            print(f"User with ID {user_id} does not exist")
            return None

    except mysql.connector.Error as e:
        print(f"Error updating user in database: {e}")
        return None
    finally:
        if connection.is_connected():
            cursor.close()

def get_user_profile(connection, user_id):
    cursor = connection.cursor(dictionary=True)

    # Fetch user data
    cursor.execute("SELECT user_id, email, username, phone_number FROM users WHERE user_id = %s", (user_id,))
    user_profile = cursor.fetchone()

    cursor.close()
    return user_profile
