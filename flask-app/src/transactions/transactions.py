from flask import Blueprint, request, jsonify, make_response
import json
from src import db

transactions = Blueprint('transactions', __name__)

@transactions.route('/transactions', methods=['POST'])
def add_new_transaction():
    
    # collecting data from the request object 
    the_data = request.json

    #extracting the variable
    sellerId = the_data['sellerId']
    buyerId = the_data['buyerId']
    ticketId = the_data['ticketId']
    date = the_data['date']

    # Constructing the query
    query = 'insert into Transactions (sellerId, buyerId, ticketId, date) values ("'
    query += sellerId + '", "'
    query += buyerId + '", "'
    query += ticketId + '", '
    query += date + ')'

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'
