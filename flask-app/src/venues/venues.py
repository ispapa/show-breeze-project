from flask import Blueprint, request, jsonify, make_response
import json
from src import db


venues = Blueprint('venue', __name__)

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