-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database ShowBreeze;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on ShowBreeze.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use ShowBreeze;

-- Put your DDL 
-- Users table
CREATE TABLE IF NOT EXISTS Users(
userId int AUTO_INCREMENT NOT NULL,
firstName varchar(50),
lastName varchar(50),
phone varchar(15),
email varchar(75) UNIQUE NOT NULL, -- Not Null based on the DDL specification
passwordHash varchar(128) NOT NULL,
numArtists int,
tixQuota int,
PRIMARY KEY (userId),
INDEX (userId, email, phone)
);

-- Venue table
CREATE TABLE IF NOT EXISTS Venue(
  venueId int AUTO_INCREMENT NOT NULL,
  capacity int NOT NULL,
  startTime DATETIME NOT NULL,
  endTIME DATETIME,
  price int,
  street varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  zip int NOT NULL,
  ownerId int NOT NULL,
  PRIMARY KEY (venueId),
  CONSTRAINT VenueToOwner FOREIGN KEY (ownerId) REFERENCES Users(userId)
          ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Events table
CREATE TABLE IF NOT EXISTS Events(
  eventId int AUTO_INCREMENT NOT NULL,
  venueId int NOT NULL ,
  name varchar(50),
  startTime DATETIME NOT NULL,
  PRIMARY KEY (eventId),
  CONSTRAINT EventToVenue FOREIGN KEY (venueId) REFERENCES Venue(venueId)
          ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Seats table 
CREATE TABLE IF NOT EXISTS Seats(
  seatId int AUTO_INCREMENT NOT NULL,
  venueId int NOT NULL,
  availability boolean NOT NULL,
  seatRow Char NOT NULL,
  seatNumber int NOT NULL,
  PRIMARY KEY (seatId),
  CONSTRAINT seatToVenue FOREIGN KEY (venueId) REFERENCES Venue(venueId)
      ON UPDATE CASCADE ON DELETE RESTRICT
);


-- Tickets table
CREATE TABLE IF NOT EXISTS Tickets(
  ticketId int AUTO_INCREMENT NOT NULL,
  eventId int NOT NULL,
  seatId int NOT NULL,
  userId int NOT NULL,
  vip boolean NOT NULL,
  price int NOT NULL,
  sold boolean NOT NULL,
  PRIMARY KEY (ticketId),
  CONSTRAINT ticketToSeat FOREIGN KEY (seatId) REFERENCES Seats(seatId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ticketToEvent FOREIGN KEY (eventId) REFERENCES Events(eventId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ticketToUser FOREIGN KEY (userId) REFERENCES Users(userId)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions(
  transactionId int AUTO_INCREMENT NOT NULL,
  sellerId int NOT NULL,
  buyId int NOT NULL,
  ticketId int NOT NULL,
  date DATETIME NOT NULL,
  PRIMARY KEY (transactionId),
  CONSTRAINT transactionToSeller FOREIGN KEY (sellerId) REFERENCES Users(userId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT transactionToBuyer FOREIGN KEY (buyId) REFERENCES Users(userId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT transactionToTicket FOREIGN KEY (ticketId) REFERENCES Tickets(ticketId)
      ON UPDATE CASCADE ON DELETE RESTRICT
);
