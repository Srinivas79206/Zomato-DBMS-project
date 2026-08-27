from flask import Flask, request, jsonify, render_template
import mysql.connector

app = Flask(__name__)


def create_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='root',
        database='zomato'
    )


# Home route
@app.route('/')
def home():
    return render_template('index.html')


# Get all menu items (with optional category filter and search)
@app.route('/api/menu', methods=['GET'])
def get_menu():
    cursor = None
    connection = None
    try:
        category = request.args.get('category', '')
        search = request.args.get('search', '')

        connection = create_connection()
        cursor = connection.cursor(dictionary=True)

        query = """
            SELECT i.item_id, i.item_name, i.price, i.description, i.image_url,
                   i.rating, i.is_bestseller, c.category_name
            FROM items i
            JOIN categories c ON i.category_id = c.category_id
            WHERE 1=1
        """
        params = []

        if category:
            query += " AND c.category_name = %s"
            params.append(category)

        if search:
            query += " AND i.item_name LIKE %s"
            params.append(f"%{search}%")

        query += " ORDER BY i.is_bestseller DESC, i.rating DESC"

        cursor.execute(query, params)
        items = cursor.fetchall()

        # Convert Decimal to float for JSON serialization
        for item in items:
            item['price'] = float(item['price'])
            item['rating'] = float(item['rating'])
            item['is_bestseller'] = bool(item['is_bestseller'])

        return jsonify({"items": items}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


# Get all categories
@app.route('/api/categories', methods=['GET'])
def get_categories():
    cursor = None
    connection = None
    try:
        connection = create_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM categories")
        categories = cursor.fetchall()
        return jsonify({"categories": categories}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


# Place an order (POST)
@app.route('/place_order', methods=['POST'])
def place_order():
    cursor = None
    connection = None
    try:
        order_data = request.get_json()

        cart = order_data.get('cart', [])
        address = order_data.get('address', '')
        payment_method = order_data.get('payment_method', 'Cash on Delivery')

        if not cart or not address:
            return jsonify({"error": "Cart is empty or address is missing."}), 400

        connection = create_connection()
        cursor = connection.cursor()

        total_amount = 0

        for item in cart:
            item_name = item['name']
            quantity = item['quantity']

            cursor.execute("SELECT item_id, price FROM items WHERE item_name = %s", (item_name,))
            result = cursor.fetchone()

            if not result:
                return jsonify({"error": f"Item {item_name} not found."}), 400

            item_id = result[0]
            price = float(result[1])
            user_id = 1

            # Insert into orders table
            sql = """
                INSERT INTO orders (user_id, item_id, quantity, delivery_address, status)
                VALUES (%s, %s, %s, %s, 'Placed')
            """
            cursor.execute(sql, (user_id, item_id, quantity, address))
            order_id = cursor.lastrowid

            # Insert into order_items table
            sql_items = """
                INSERT INTO order_items (order_id, item_id, quantity, price)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(sql_items, (order_id, item_id, quantity, price))

            total_amount += price * quantity

            # Insert payment record
            sql_payment = """
                INSERT INTO payments (order_id, payment_method, payment_status, amount)
                VALUES (%s, %s, 'Pending', %s)
            """
            cursor.execute(sql_payment, (order_id, payment_method, price * quantity))

        connection.commit()
        return jsonify({
            "message": "Order placed successfully!",
            "total": total_amount,
            "order_id": order_id
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


# Get all orders (GET)
@app.route('/orders', methods=['GET'])
def get_orders():
    cursor = None
    connection = None
    try:
        connection = create_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT o.order_id, o.quantity, o.delivery_address, o.order_date, o.status,
                   i.item_name, i.price
            FROM orders o
            JOIN items i ON o.item_id = i.item_id
            ORDER BY o.order_date DESC
        """)
        orders = cursor.fetchall()

        for order in orders:
            order['price'] = float(order['price'])
            order['order_date'] = str(order['order_date'])

        return jsonify({"orders": orders}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


if __name__ == '__main__':
    app.run(debug=True)
