from flask import Blueprint, request, jsonify, make_response
import json
from src import db


venue = Blueprint('venue', __name__)

# Get all venues from the DB
@venue.route('/venue', methods=['GET'])
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

# Adds a new Venue to the database
@venue.route('/venue', methods=['POST'])
def add_new_venue():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    name = the_data['venue_name']
    capacity = the_data['venue_capacity']
    startTime = the_data['venue_start']
    endTime = the_data['venue_end']
    price = the_data['venue_price']
    street = the_data['venue_street']
    city = the_data['venue_city']
    state = the_data['venue_state']
    zip = the_data['venue_zip']
    ownerId = the_data['venue_ownerId']

    # Constructing the query
    query = 'insert into products (name, capacity, startTime, endtime, price, street, city, state, zip, ownerId) values ("'
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
    
    return 'Success!'


# Get venue detail for Venues with particular userID
@venue.route('/venue/<userID>', methods=['GET'])
def get_venue(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Venues where id = {0}'.format(userID))
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
@venue.route('/venue/<userID>', methods=['PUT'])
def update_venue(venueId):
    #Getting the Data
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variables
    name = the_data['venue_name']
    capacity = the_data['venue_capacity']
    startTime = the_data['venue_start']
    endTime = the_data['venue_end']
    price = the_data['venue_price']
    street = the_data['venue_street']
    city = the_data['venue_city']
    state = the_data['venue_state']
    zip = the_data['venue_zip']
    ownerId = the_data['venue_ownerId']
    venueId = the_data['venueId']
    
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
    + ', venueId = ' + str(venueId)  
    + ' WHERE ticketId = ' + str(venueId) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(venue_update)
    db.get_db().commit()

    return "successfully updated venue #{0}!".format(venueId)