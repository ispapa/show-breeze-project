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

    seatId = the_data['Seat ID']

    # Constructing the query
    seats_update = f'UPDATE `Seats` SET availability = FALSE WHERE seatId = {seatId};'

    cursor = db.get_db().cursor()
    cursor.execute(seats_update)
    db.get_db().commit()
    
    return f"Successfully updated seat with ID {seatId}"

# Deletes a venue based on the veneuId
@seats.route('/seats/<int:seatId>', methods=['DELETE'])
def delete_seat(seatId):
    seat_delete = 'DELETE FROM Seats WHERE seatId = ' + str(seatId) + ';'
    
    cursor = db.get_db().cursor()
    cursor.execute(seat_delete)
    db.get_db().commit()
    return "successfully deleted seat #{0}!".format(seatId)

