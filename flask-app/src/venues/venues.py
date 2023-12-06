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

# Get venue details for venues with particular userID
@venues.route('/venues/<userID>', methods=['GET'])
def get_customer(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Venues where ownerId = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## viewing all seats in a venue
@venues.route('/venues/<int:venueId>', methods=['GET'])
##getting all seats for each venueId
def get_seats(venueId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from Seats where venueId = {0}'.format(venueId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# View the seats available at the venue
@venues.route('/venues/<int:venueId>/seats', methods=['GET'])
def get_available_seats(venueId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Seats WHERE venueId = %s AND availability = %s;', (str(venueId), True))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    venue_data = cursor.fetchall()
    for row in venue_data:
        json_data.append(dict(zip(row_headers, row)))
    response = jsonify(json_data)
    response.status_code = 200
    return response