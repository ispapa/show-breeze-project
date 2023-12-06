from flask import Blueprint, request, jsonify, make_response
import json
from src import db


tickets = Blueprint('tickets', __name__)

# Get all tickets associated with userId 21
@tickets.route('/tickets', methods=['GET'])
def get_tickets():
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT
            t.ticketId as 'Ticket ID',
            e.name AS 'Event Name',
            e.startTime AS 'Event Time',
            v.name AS 'Venue Name',
            s.seatRow AS 'Seat Row',
            s.seatNumber AS 'Seat Number',
            t.price AS 'Purchase Price',
            CASE WHEN t.vip = 1 THEN 'Yes' ELSE 'No' END AS 'VIP'
        FROM Tickets t
        JOIN Events e ON t.eventId = e.eventId
        JOIN Venues v ON e.venueId = v.venueId
        JOIN Seats s ON t.seatId = s.seatId
        WHERE t.userId = 21;
        ''' )

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))

    response = jsonify(json_data)
    response.status_code = 200
    response.mimetype = 'application/json'
    
    return response



# Changes userId and price of ticket (for resale transaction)
@tickets.route('/editTicket/<ticketId>', methods=['PUT'])
def update_ticket(ticketId):
    
    the_data = request.json

    ticketId = the_data['ticketId']
    buyerEmail = the_data['buyerEmail']
    new_price = the_data['price']

    # Get buyer ID
    cursor = db.get_db().cursor()
    cursor.execute('SELECT userId FROM Users WHERE email = %s', (buyerEmail,))
    buyerId = cursor.fetchone()[0]
    if not buyerId:
        return 'Buyer not found!', 404

    # update price + user id 
    ticket_query = 'UPDATE Tickets SET userId = ' + str(buyerId) + ', price =  ' + str(new_price) + ' WHERE ticketId = ' + str(ticketId) + ';'

    cursor.execute(ticket_query)
    db.get_db().commit()

    return "successfully edited ticket #{0}!".format(ticketId)