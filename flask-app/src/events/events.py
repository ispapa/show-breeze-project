from flask import Blueprint, request, jsonify, make_response
import json
from src import db

events = Blueprint('events', __name__)

# Get all events from the DB
@events.route('/events', methods=['GET'])
def get_events():
    cursor = db.get_db().cursor()
    cursor.execute('''
        SELECT e.name AS 'Event Name', e.startTime as 'Event Date', v.name AS 'Venue Name'
        FROM Events e
        JOIN Venues v ON e.venueId = v.venueId
        ORDER BY 'Event Date'
        ''')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
