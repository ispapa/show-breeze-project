from flask import Blueprint, request, jsonify, make_response
import json
from src import db


users = Blueprint('users', __name__)

# Get all users from the DB
@users.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from Users')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Posts a user to the DB
@users.route('/users', methods=['POST'])
def add_users():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    firstName = the_data['firstName']
    lastName = the_data['lastName']
    phone = the_data['phone']
    email = the_data['email']
    passwordHash = the_data['passwordHash']
    numArtists = the_data['numArtists']
    tixQuota = the_data['tixQuota']

    # Constructing the query
    query = 'insert into users (firstName, lastName, phone, email, passwordHash, numArtists, tixQuota) values ("'
    query += firstName + '", "'
    query += lastName + '", "'
    query += str(phone) + '", "'
    query += email + '", "'
    query += passwordHash + '", "'
    query += str(numArtists) + '", "'
    query += str(tixQuota) + '")'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return "Successfully posted a new user named " + firstName + " " + lastName 

# Get a user by the userId from the DB
@users.route('/users/<int:userId>', methods=['GET'])
def get_users_from_userId(userId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from Users where id = {0}'.format(userId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Updates a users with the given userId in the DB
@users.route('/users/<int:userId>', methods=['PUT'])
def update_users(userId):
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable=
    firstName = the_data['firstName']
    lastName = the_data['lastName']
    phone = the_data['phone']
    email = the_data['email']
    passwordHash = the_data['passwordHash']
    numArtists = the_data['numArtists']
    tixQuota = the_data['tixQuota']

    # Constructing the query
    query = 'UPDATE `Venues` SET firstName = ' + firstName
    + ", lastName = " + lastName
    + ", phone = " + str(phone)
    + ", email = " + email
    + ", passwordHash = " + passwordHash
    + ", numArtists = " + str(numArtists)
    + ", tixQuota = " + str(tixQuota)
    + " WHERE userId = " + str(userId) + ";" 
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return "Successfully posted a new user named " + firstName + " " + lastName 