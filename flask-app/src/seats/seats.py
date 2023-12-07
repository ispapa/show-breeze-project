from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

seats = Blueprint('seats', __name__)

# Updates a current seat to the database
@seats.route('/seats/<seatId>', methods=['PUT'])
def update_seat(seatId):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    venueId = the_data['venueId']
    availability = the_data['availability']
    seatRow = the_data['seatRow']
    seatNumber = the_data['seatNumber']

    # Constructing the query
    seats_update = 'UPDATE `Seats` SET seatId = "' + seatId
    seats_update += '", venueId = "' + venueId
    seats_update += '", availability = "' + availability
    seats_update += '", seatRow = "' + seatRow
    seats_update += '", seatNumber = "' + seatNumber
    seats_update += '" WHERE seatId = ' + str(seatId) + ';'


    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(seats_update)
    db.get_db().commit()
    
    return "Successfully updated seat with ID " + str(seatId)

# Deletes a venue based on the veneuId
@seats.route('/seats/<int:seatId>', methods=['DELETE'])
def delete_seat(seatId):
    seat_delete = 'DELETE FROM Seats WHERE seatId = ' + str(seatId) + ';'
    
    cursor = db.get_db().cursor()
    cursor.execute(seat_delete)
    db.get_db().commit()
    return "successfully deleted seat #{0}!".format(seatId)

