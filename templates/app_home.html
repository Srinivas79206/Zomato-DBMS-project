from flask import Flask, request, jsonify, render_template
import mysql.connector

app = Flask(__name__)

# Function to create a connection to MySQL database
def create_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',  # Replace with your MySQL username
        password='root',  # Replace with your MySQL password
        database='zomato'  # Database name
    )

# Home route: renders the index.html page
@app.route('/')
def home():
    return render_template('home.html')

# Place an order route: handles form submissions
@app.route('/place_order', methods=['POST'])
def place_order():
    connection = None
    cursor = None
    try:
        # Get data from the form submission
        biriyani_quantity = request.form.get('biriyani_quantity', 0)
        paneer_quantity = request.form.get('paneer_quantity', 0)
        butter_chicken_quantity = request.form.get('butter_chicken_quantity', 0)
        address = request.form.get('address')

        # Process the cart (items selected by the user)
        cart = []
        if int(biriyani_quantity) > 0:
            cart.append(('Biriyani', int(biriyani_quantity)))
        if int(paneer_quantity) > 0:
            cart.append(('Paneer', int(paneer_quantity)))
        if int(butter_chicken_quantity) > 0:
            cart.append(('Butter Chicken', int(butter_chicken_quantity)))

        # Check if cart is empty or address is missing
        if not cart or not address:
            return jsonify({"error": "Cart is empty or address is missing."}), 400

        # Insert order details into the database
        connection = create_connection()
        cursor = connection.cursor()

        for item_name, quantity in cart:
            cursor.execute("SELECT item_id FROM items WHERE item_name = %s", (item_name,))
            result = cursor.fetchone()

            if not result:
                return jsonify({"error": f"Item {item_name} not found."}), 400

            item_id = result[0]  # Get the item_id from the query result
            user_id = 1  # Assuming user_id is 1 (you can change this if needed)

            # SQL query to insert the order into the orders table
            sql = """
                INSERT INTO orders (user_id, item_id, quantity, delivery_address)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(sql, (user_id, item_id, quantity, address))

        # Commit the transaction to save the changes in the database
        connection.commit()
        return jsonify({"message": "Order placed successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# Run the Flask application
if __name__ == '__main__':
    app.run(debug=True)
