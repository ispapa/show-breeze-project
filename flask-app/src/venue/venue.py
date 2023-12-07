from flask import Blueprint, request, jsonify, make_response
import json
from src import db


venues = Blueprint('venues', __name__)

# Get all venues from the DB
@venues.route('/venues', methods=['GET'])
def get_venue():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from Venues')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Adds a new venue to the database
@venues.route('/venues', methods=['POST'])
def add_new_venue():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    name = the_data['name']
    capacity = the_data['capacity']
    startTime = the_data['start']
    endTime = the_data['end']
    price = the_data['price']
    street = the_data['street']
    city = the_data['city']
    state = the_data['state']
    zip = the_data['zip']
    ownerId = the_data['ownerId']

    # Constructing the query
    query = 'insert into Venues (name, capacity, startTime, endtime, price, street, city, state, zip, ownerId) values ("'
    query += name + '", "'
    query += str(capacity) + '", "'
    query += startTime + '", '
    query += endTime + '", '
    query += str(price) + '", '
    query += street + '", '
    query += city + '", '
    query += state + '", '
    query += zip + '", '
    query += str(ownerId) + '", '')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return "Successfully posted a new venues named " + name


# Get venues detail for Venues with particular userID
@venues.route('/venues/<int:venueId>', methods=['GET'])
def get_venue_from_venueId(venueId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Venues where venueId = ' + str(venueId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Updates all the data for the venueId with the request.json,
# Ideally if some data does not change the request.json will have it unchanged
@venues.route('/venues/<int:venueId>', methods=['PUT'])
def update_venue(venueId):
    #Getting the Data
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variables
    name = the_data['name']
    capacity = the_data['capacity']
    startTime = the_data['start']
    endTime = the_data['end']
    price = the_data['price']
    street = the_data['street']
    city = the_data['city']
    state = the_data['state']
    zip = the_data['zip']
    ownerId = the_data['ownerId']
    
    # update price + user id 
    venue_update = 'UPDATE `Venues` SET name = ' + name
    + ', capacity = ' + capacity
    + ', startTime = ' + startTime
    + ', endTime = ' + endTime
    + ', price = ' + str(price) 
    + ', street = ' + street
    + ', city = ' + city
    + ', state = ' + state
    + ', zip = ' + zip 
    + ', ownerId = ' + str(ownerId)  
    + ' WHERE venueId = ' + str(venueId) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(venue_update)
    db.get_db().commit()

    return "successfully updated venues #{0}!".format(venueId)

# Deletes a venue based on the veneuId
@venues.route('/venues/<int:venueId>', methods=['DELETE'])
def delete_venue(venueId):
    venue_delete = 'DELETE FROM Venues WHERE venueId = ' + str(venueId) + ';'
    
    cursor = db.get_db().cursor()
    cursor.execute(venue_delete)
    db.get_db().commit()
    return "successfully deleted venues #{0}!".format(venueId)

# Get a venue detail for Venues with particular userID
@venues.route('/venues/<venueId>/seats', methods=['GET'])
def get_venue_seats_from_venueId(venueId):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Seats where venueId = {0}'.format(venueId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Adds a new seat to a given venues by their venueId
@venues.route('/venues/<venueId>/seats', methods=['POST'])
def add_new_venue_seat(venueId):
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    availability = the_data['seat_availability']
    seatRow = the_data['seat_seatRow']
    seatNumber = the_data['seat_seatNumber']

    # Constructing the query
    query = 'insert into Seats (venueId, availability, seatRow, seatNumber) values ("'
    query += venueId + '", "'
    query += str(availability) + '", "'
    query += str(seatRow) + '", '
    query += str(seatNumber) + '")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return "Successfully posted a new seat in venueId = " + venueId + ", seatRow = " + seatRow + ", seatNumber = " + seatNumber 