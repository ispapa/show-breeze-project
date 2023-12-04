from flask import Blueprint, request, jsonify, make_response
import json
from src import db


tickets = Blueprint('tickets', __name__)

# Get customer detail for customer with particular userID
@tickets.route('/tickets/<ticketId>', methods=['GET'])
def get_ticket(ticketId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Tickets where ticketId = {0}'.format(ticketId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Changes userId and price of ticket (for resale transaction)
@tickets.route('/editTicket/<ticketId>', methods=['PUT'])
def update_ticket(ticketId):
    
    the_data = request.json

    ticketId = the_data['ticketId']
    new_user_id = the_data['userId']
    new_price = the_data['price']
    
    ticketInfo = get_ticket(ticketId)
    
    ticketId = str(ticketInfo['ticketId'])
    prev_price = str(ticketInfo['price'])
    
    # calculate price change (if any)
    price_change = float(new_price) - float(prev_price)
    
    # update price + user id 
    ticket_query = 'UPDATE `Tickets` SET userId = ' + str(new_user_id) + ', price = price + ' + str(price_change) + ' WHERE ticketId = ' + str(ticketId) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(ticket_query)
    db.get_db().commit()

    return "successfully edited ticket #{0}!".format(ticketId)