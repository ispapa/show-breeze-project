from flask import Blueprint, request, jsonify, make_response
import json
from src import db

transactions = Blueprint('transactions', __name__)

@transactions.route('/transactions', methods=['POST'])
def add_new_transaction():
    
    # collecting data from the request object 
    the_data = request.json

    #extracting the variable
    sellerEmail = the_data['sellerEmail']
    buyerEmail = the_data['buyerEmail']
    ticketId = the_data['ticketId']
    price = the_data['price']

    
    # Querying user IDs based on emails
    cursor = db.get_db().cursor()

    # Get seller ID
    cursor.execute('SELECT userId FROM Users WHERE email = %s', (sellerEmail,))
    sellerId = cursor.fetchone()[0]
    if not sellerId:
        return 'Seller not found!', 404

    # Get buyer ID
    cursor.execute('SELECT userId FROM Users WHERE email = %s', (buyerEmail,))
    buyerId = cursor.fetchone()[0]
    if not buyerId:
        return 'Buyer not found!', 404

    # Constructing the query
    query = 'insert into Transactions (sellerId, buyerId, ticketId, date, price) values ("'
    query += str(sellerId) + '", "'
    query += str(buyerId) + '", "'
    query += str(ticketId) + '", '
    query += 'NOW(), '
    query += str(price) + ')'

    # executing and committing the insert statement 
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'
