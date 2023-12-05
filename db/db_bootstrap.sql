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
CREATE TABLE IF NOT EXISTS Venues(
  venueId int AUTO_INCREMENT NOT NULL,
  name varchar(50) NOT NULL,
  capacity int NOT NULL,
  startTime DATE NOT NULL,
  endTIME DATE,
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
  performerId int NOT NULL,
  PRIMARY KEY (eventId),
  CONSTRAINT EventToVenue FOREIGN KEY (venueId) REFERENCES Venues(venueId)
          ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT EventToPerformer FOREIGN KEY (performerId) REFERENCES Users(userId)
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
  CONSTRAINT seatToVenue FOREIGN KEY (venueId) REFERENCES Venues(venueId)
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
  buyerId int NOT NULL,
  ticketId int NOT NULL,
  date DATETIME NOT NULL,
  price int NOT NULL,
  PRIMARY KEY (transactionId),
  CONSTRAINT transactionToSeller FOREIGN KEY (sellerId) REFERENCES Users(userId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT transactionToBuyer FOREIGN KEY (buyerId) REFERENCES Users(userId)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT transactionToTicket FOREIGN KEY (ticketId) REFERENCES Tickets(ticketId)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Users data 
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota, numArtists) VALUES (1,'Elfrieda','Ennals','eennals0@uol.com.br','$2a$04$G8HXcgHh3fGEEwVMg8xJMu/xZYdy0KgmfdrT2j/R79xJqBbaskHhK',989,8);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota, numArtists) VALUES (2,'Heath','Parrish','hparrish1@si.edu','$2a$04$Joe.I09tOeKy8Vpw9.4vG.5B/TLiIwUNqYB0fQYvzP1OgHXM/HU6e',781,3);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (3,'Jess','Smullin','jsmullin2@hugedomains.com','$2a$04$4rHgp0jRZXNGLTCT159nEOLxX8L1e6hESnj7VWPxWLUSkA/n.SxuC',698);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (4,'Cindelyn','Simpkiss','csimpkiss3@so-net.ne.jp','$2a$04$G63Fbo/Z8hnsKh1Hg0Fd2OsD/Cz58kO9z0ZM1rTLADQKwCsFjps0u',6);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (5,'Friedrich','Missenden','fmissenden4@biglobe.ne.jp','$2a$04$z6FL.QKsw8huNciDxs2nae7FT/BN1kvL31FE1hJF4.eqi7Dg7ovKa',9);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (6,'Farrel','Ogelsby','fogelsby5@de.vu','$2a$04$5NvY33u9fBGFBFmqvGLDP.uvoxDHPyFJMvSGff4FyR6ek8.J3hW7G',619);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (7,'Beverlie','MacDunleavy','bmacdunleavy6@netscape.com','$2a$04$rK70C.Osp9.Zik74wCLH5.DOo1Hj8vzsyEBed3k87LXcFXY0DcRqO',743);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (8,'Shanta','Preist','spreist7@dion.ne.jp','$2a$04$7g7Qf5MvTIhI.NjOfJVHFeeVy0eJtYIOrlX2YrqpM08lhWs1fXoLS',964);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash) VALUES (9,'Miriam','Geer','mgeer8@google.es','$2a$04$Rpr998TsF/9tGIO0o6mY/OPUC2lxPmoVhb2MRppDBdAPgGG0nTfrm');
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (10,'Cullen','Muckleston','cmuckleston9@redcross.org','$2a$04$S7RDWNfiZUbCx6J.85J7r.JKjZ63Cv/ftvlmPinBQ95V1/nJohiQ.',9);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (11,'Farris','Tappington','ftappingtona@posterous.com','$2a$04$cQMT.fbWRZSTdui5w7iM7uXkQyR9TOur8HXOZPx7TMIx.xFzLGcES',291);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (12,'Jeffry','Blasi','jblasib@drupal.org','$2a$04$D.VcCC62c15ezOsqqNQs5utAqk03D7y58zjYtMoJFhj6p6MDEsHIK',3);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (13,'Erik','McKeney','emckeneyc@msu.edu','$2a$04$3h.N9MbVpEJ7xkFvRZ3XCOlAp0xThZ1YMWi9SrdJPXCxJebb6mlPe',298);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists, tixQuota) VALUES (14,'Dulcea','Romney','dromneyd@engadget.com','$2a$04$.K/V4ou8VSKq2HW54.J2U.fF/angUCns.BTwwCLQdkcy04xninkBe',319,8);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (15,'Lucina','Lauritsen','llauritsene@utexas.edu','$2a$04$v4wqw7urM8AkEFk.qYg/We4NoWXOjNDLZCxcLYjbOQcHzmXViFtvW',10);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash) VALUES (16,'Orin','Keemer','okeemerf@drupal.org','$2a$04$EpPA.jXMjJSGleK5ijVNMuSm8/XJ7IKRpMhRIw32NS.EFPPGAMFom');
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (17,'Loretta','Ox','loxg@wikimedia.org','$2a$04$XwWRdAltRRKYPg/g65m31upiOJdVGOww5KDQKTqZw7k3Rl06oGEve',3);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash) VALUES (18,'Shane','Elvin','selvinh@google.pl','$2a$04$IQv/qgVgRd9R89RhDtq0reeqoEsQ73PVh2837028QeG1jinJ0OrVi');
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (19,'Goober','Simmance','gsimmancei@angelfire.com','$2a$04$MjrjFGjSD.HjsXTVvFEJ0OmjFlwI/YXDGsNvPQ1Gw8WisUUtvTCFi',1);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (20,'Cyndie','Delatour','cdelatourj@altervista.org','$2a$04$S40baqL3Xel4s6xM8O9s8.ZO6peAJBoOJqjaySm2TG969gv92PMDy',312);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota, numArtists) VALUES (21,'Abelard','Tuckwell','atuckwellk@icio.us','$2a$04$9jP6wKA6n3qajQRIxvcVMOYg3CH9JZ8Mn76KY7bspJUE7maMy.kcS',949,3);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (22,'Theresina','Weiner','tweinerl@gizmodo.com','$2a$04$3.TTlxTDa7xHr2/V.Z3H7O6/VWvumtX/R.QNiqpGHYXvGVNVx3gpO',5);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (23,'Vern','Santino','vsantinom@hc360.com','$2a$04$kk1yq44RQYUqzFWrHqh8Je2lldOOlIwHuBhsm4x1/y7l2bXnJlcfi',9);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash) VALUES (24,'Roma','Veivers','rveiversn@fda.gov','$2a$04$ZdmoUsW/vEfjhSa.P7PkFuCDeARdyFT7v4s77Q05nXEnMHQgq8Qgy');
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota) VALUES (25,'Hanny','Barnhill','hbarnhillo@cdbaby.com','$2a$04$lZe6FIZySGHPgCvEbNsg.u/sin85r7dTJXE1edYVUw.Sx35r.aX.m',772);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, tixQuota, numArtists) VALUES (26,'Alvin','Sheldon','asheldonp@ebay.com','$2a$04$67vaFVxYGHTkbtbpr/iJiub5yo.aWjbO6gD9Pwaiax9bt2mpUfiJO',211,8);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (27,'Currey','Tregea','ctregeaq@craigslist.org','$2a$04$ubAn2tatcEfSDqhv8Jb5YOr2PoUPdCgCEhKQhJX0yNmC34bzRXOiC',5);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (28,'Flossie','Gammade','fgammader@drupal.org','$2a$04$p/Idfvp8wNQXIBdDiR0cReP88ky/INypg3Ob6PC6YklSJA8rwy8M.',10);
INSERT INTO Users (userId, firstName, lastName, email, passwordHash) VALUES (29,'Mason','Sterte','mstertes@bbc.co.uk','$2a$04$aM86AH83Z7tobT7nuHPwseNwxTkqm7X1u24NFu9KZYeLTwdnqzAFG');
INSERT INTO Users (userId, firstName, lastName, email, passwordHash, numArtists) VALUES (30,'Jacynth','Tickel','jtickelt@discuz.net','$2a$04$E8Nk3yaLc/N/Js534aD3Fe0MsZdGKSuXmb0kd.FcV2vIWD02mirRK',1);

-- Venues data 
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (1, 'Alternative Alley', 16506, '2022-06-14', '2023-11-16', 42809.81, '2688 Upham Plaza', 'Philadelphia', 'Pennsylvania', 19131, 13);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (2, 'University Hall', 7815, '2021-08-11', '2021-10-06', 31290.86, '3 Cardinal Hill', 'Louisville', 'Kentucky', 40205, 21);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (3, 'Cozy Lounge', 8699, '2023-06-04', '2023-07-22', 48713.21, '6 Packers Parkway', 'Columbus', 'Ohio', 43240, 29);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (4, 'Intimate Space', 12764, '2021-01-22', '2021-10-09', 8868.88, '993 Morningstar Street', 'Miami', 'Florida', 33129, 24);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (5, 'Student Center Auditorium', 17456, '2022-05-25', '2023-10-08', 13924.7, '54 Mayfield Avenue', 'Los Angeles', 'California', 90094, 1);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (6, 'Local Pub Stage', 13941, '2022-09-21', '2023-05-11', 10116.6, '22813 Service Hill', 'Shreveport', 'Louisiana', 71161, 7);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (7, 'The Underground', 8135, '2022-02-01', '2022-09-09', 4165.78, '1952 Graceland Drive', 'El Paso', 'Texas', 79994, 5);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (8, 'Tiny Theater', 17845, '2021-08-08', '2023-04-21', 28212.01, '33 Reindahl Avenue', 'Sioux Falls', 'South Dakota', 57188, 30);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (9, 'Community Center', 6998, '2022-11-28', '2023-07-16', 48040.05, '5 Debs Point', 'Miami', 'Florida', 33245, 30);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (10, 'Coffeehouse Corner', 6651, '2021-01-22', '2023-01-31', 26270.4, '02920 Doe Crossing Street', 'Erie', 'Pennsylvania', 16550, 3);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (11, 'Basement Club', 7958, '2022-12-22', '2022-02-27', 44391.02, '13 Dixon Street', 'Norwalk', 'Connecticut', 6859, 10);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (12, 'Acoustic Haven', 17675, '2021-05-01', '2023-10-30', 11277.22, '7000 New Castle Road', 'New Haven', 'Connecticut', 6533, 2);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (13, 'Town Hall Theatre', 6868, '2022-01-08', '2023-01-14', 20675.76, '8803 Vera Place', 'Toledo', 'Ohio', 43615, 23);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (14, 'Campus Amphitheater', 8980, '2021-12-17', '2021-05-09', 31531.21, '0 Mifflin Pass', 'Tallahassee', 'Florida', 32304, 10);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (15, 'Pub Basement', 11679, '2022-10-03', '2022-11-01', 9929.31, '5 South Alley', 'Colorado Springs', 'Colorado', 80915, 3);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (16, 'Corner Cafe', 10134, '2023-09-05', '2022-02-05', 15216.43, '0 Lotheville Trail', 'New York City', 'New York', 10280, 8);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (17, 'Artist Loft', 12702, '2021-12-19', '2021-09-08', 22503.11, '26800 Roxbury Point', 'San Jose', 'California', 95194, 5);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (18, 'Studio Stage', 14656, '2021-12-03', '2021-03-15', 12467.65, '2 Hudson Circle', 'Philadelphia', 'Pennsylvania', 19172, 20);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (19, 'Micro Music Hall', 7397, '2022-03-12', '2022-06-20', 45407.62, '04723 Mesta Terrace', 'Boca Raton', 'Florida', 33432, 29);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (20, 'Hidden Gem Hall', 11172, '2023-06-26', '2021-12-21', 37929.96, '34943 Gale Alley', 'Fairbanks', 'Alaska', 99790, 11);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (21, 'College Courtyard', 12288, '2023-09-04', '2022-11-24', 24859.53, '949 Thackeray Way', 'Odessa', 'Texas', 79764, 24);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (22, 'Cultural Center', 13711, '2021-09-16', '2023-08-06', 25282.92, '8125 Fair Oaks Plaza', 'Minneapolis', 'Minnesota', 55428, 24);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (23, 'Quaint Auditorium', 11020, '2021-05-07', '2021-06-05', 11597.4, '37 Colorado Alley', 'Hartford', 'Connecticut', 6183, 2);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (24, 'Village Hall', 8724, '2023-03-06', '2022-04-29', 33931.45, '826 Milwaukee Place', 'New Haven', 'Connecticut', 6510, 15);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (25, 'Singer''s Spot', 8563, '2023-09-17', '2021-08-23', 20260.41, '92282 Carioca Drive', 'New Orleans', 'Louisiana', 70187, 14);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (26, 'Student Union Lounge', 19292, '2023-10-27', '2022-04-28', 31250.14, '41 Crowley Point', 'Stamford', 'Connecticut', 6922, 21);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (27, 'Hometown Stage', 13594, '2023-08-02', '2023-03-21', 38053.99, '052 Sunnyside Parkway', 'Kent', 'Washington', 98042, 15);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (28, 'Little Loft', 17675, '2023-06-09', '2021-05-23', 711.9, '31 Lawn Trail', 'Kansas City', 'Missouri', 64142, 16);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (29, 'Alumni Auditorium', 8050, '2022-04-13', '2021-07-05', 21384.37, '12605 Golf View Circle', 'Arlington', 'Virginia', 22217, 14);
INSERT INTO Venues (venueId, name, capacity, startTime, endTime, price, street, city, state, zip, ownerId) VALUES (30, 'Backyard Amphitheater', 7930, '2021-08-30', '2023-07-19', 10894.98, '229 Sachtjen Hill', 'Dallas', 'Texas', 75236, 12);

-- Events data 
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (1, 11, 'Arctic Monkeys', '2023-02-15 18:30:00', 5);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (2, 26, 'Red Hot Chili Peppers', '2023-02-20 19:00:00', 12);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (3, 21, 'Mumford & Sons', '2023-03-05 20:15:00', 8);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (4, 28, 'Coldplay', '2023-03-12 21:30:00', 17);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (5, 7, 'Foo Fighters', '2023-03-25 22:45:00', 22);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (6, 14, 'Beyonce', '2023-04-10 18:00:00', 3);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (7, 26, 'Radiohead', '2023-04-18 19:30:00', 14);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (8, 3, 'The Rolling Stones', '2023-05-02 20:45:00', 29);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (9, 16, 'U2', '2023-05-15 21:15:00', 7);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (10, 23, 'Taylor Swift', '2023-06-01 22:30:00', 18);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (11, 5, 'Adele', '2023-06-10 18:45:00', 24);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (12, 27, 'Ed Sheeran', '2023-06-25 19:00:00', 13);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (13, 7, 'Pink Floyd', '2023-07-10 20:15:00', 2);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (14, 23, 'The Weeknd', '2023-07-18 21:30:00', 9);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (15, 21, 'Kanye West', '2023-08-02 22:45:00', 20);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (16, 10, 'Metallica', '2023-08-15 18:00:00', 1);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (17, 28, 'Bruno Mars', '2023-09-01 19:30:00', 28);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (18, 3, 'Queen', '2023-09-10 20:45:00', 19);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (19, 22, 'Justin Bieber', '2023-09-25 21:15:00', 11);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (20, 11, 'Drake', '2023-10-10 22:30:00', 26);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (21, 10, 'Elton John', '2023-10-18 18:45:00', 5);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (22, 16, 'Celine Dion', '2023-11-02 19:00:00', 15);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (23, 25, 'The Eagles', '2023-11-15 20:15:00', 10);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (24, 11, 'Shawn Mendes', '2023-12-01 21:30:00', 21);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (25, 7, 'The Killers', '2023-12-10 22:45:00', 23);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (26, 6, 'AC/DC', '2024-01-02 18:00:00', 6);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (27, 22, 'Lady Gaga', '2024-01-15 19:30:00', 30);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (28, 12, 'The Who', '2024-02-01 20:45:00', 4);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (29, 6, 'Kendrick Lamar', '2024-02-10 21:15:00', 27);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (30, 4, 'Imagine Dragons', '2024-02-25 22:30:00', 16);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (31, 1, 'Sam Smith', '2024-03-10 18:45:00', 8);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (32, 26, 'Mariana''s Trench', '2024-03-20 19:00:00', 26);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (33, 1, 'Billie Eilish', '2024-04-05 20:15:00', 19);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (34, 25, 'Travis Scott', '2024-04-12 21:30:00', 11);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (35, 6, 'The Lumineers', '2024-04-25 22:45:00', 22);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (36, 12, 'Lana Del Rey', '2024-05-10 18:00:00', 7);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (37, 12, 'Rihanna', '2024-05-18 19:30:00', 15);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (38, 8, 'John Mayer', '2024-06-02 20:45:00', 1);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (39, 28, 'Eminem', '2024-06-15 21:15:00', 28);
INSERT INTO Events (eventId, venueId, name, startTime, performerId) VALUES (40, 8, 'Ariana Grande', '2024-03-10 22:30:00', 5);

-- Seats data 
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (1,18,FALSE,'Q',16);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (2,16,FALSE,'J',31);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber)  VALUES (3,8,FALSE,'A',33);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (4,24,FALSE,'R',16);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (5,10,FALSE,'L',49);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (6,20,TRUE,'P',27);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (7,9,FALSE,'S',12);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (8,15,FALSE,'U',12);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (9,10,FALSE,'M',30);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (10,18,FALSE,'N',48);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (11,15,TRUE,'B',25);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (12,16,FALSE,'G',39);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (13,20,FALSE,'C',33);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (14,28,FALSE,'E',3);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (15,5,TRUE,'F',17);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (16,21,FALSE,'D',24);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (17,26,TRUE,'V',38);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (18,11,TRUE,'T',24);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (19,16,TRUE,'W',7);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (20,28,FALSE,'Y',4);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (21,21,TRUE,'H',23);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (22,7,FALSE,'K',41);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (23,5,TRUE,'X',12);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (24,26,FALSE,'I',1);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (25,25,TRUE,'O',16);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (26,25,TRUE,'Z',49);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (27,4,FALSE,'Q',45);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (28,8,FALSE,'A',28);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (29,4,FALSE,'L',50);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (30,15,FALSE,'P',33);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (31,11,FALSE,'J',10);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (32,28,TRUE,'U',7);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (33,25,FALSE,'X',31);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (34,10,TRUE,'O',41);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (35,17,FALSE,'V',6);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (36,3,FALSE,'W',16);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (37,23,FALSE,'Z',42);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (38,10,FALSE,'B',7);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (39,7,TRUE,'R',4);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (40,19,FALSE,'C',13);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (41,13,FALSE,'S',7);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (42,18,TRUE,'M',17);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (43,18,TRUE,'Y',23);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (44,22,FALSE,'I',15);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (45,12,FALSE,'F',22);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (46,29,FALSE,'N',11);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (47,22,TRUE,'H',38);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (48,30,TRUE,'E',30);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (49,25,TRUE,'G',19);
INSERT INTO Seats (seatId, venueId, availability, seatRow, seatNumber) VALUES (50,18,FALSE,'D',47);


-- Tickets data 
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (1,19,33,12,FALSE,164.57,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (2,5,2,9,FALSE,78.02,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (3,19,8,25,FALSE,62.48,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (4,26,32,18,TRUE,119.41,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (5,13,41,28,FALSE,74.52,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (6,40,31,15,TRUE,105.64,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (7,11,11,24,FALSE,81.02,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (8,9,14,1,FALSE,128.38,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (9,7,11,4,TRUE,151.51,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (10,16,10,15,TRUE,32.82,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (11,38,14,30,TRUE,72.38,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (12,25,24,12,TRUE,84.59,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (13,12,48,21,TRUE,123.53,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (14,19,6,1,FALSE,14.66,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (15,3,26,29,FALSE,196.25,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (16,36,27,27,FALSE,71.08,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (17,20,4,13,TRUE,73.71,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (18,9,33,28,FALSE,164.6,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (19,12,49,22,FALSE,106.74,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (20,22,41,22,TRUE,155.6,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (21,11,5,5,FALSE,154.68,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (22,8,36,5,FALSE,97.95,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (23,2,49,10,FALSE,199.26,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (24,29,13,10,FALSE,34.22,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (25,39,45,25,FALSE,92.95,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (26,5,36,14,FALSE,104.63,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (27,37,48,26,TRUE,164.52,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (28,40,23,2,FALSE,42.32,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (29,1,6,13,TRUE,195.7,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (30,2,9,15,TRUE,154.85,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (31,3,5,12,TRUE,29.32,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (32,1,3,21,TRUE,165.93,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (33,15,16,28,TRUE,159.71,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (34,11,3,21,TRUE,122.58,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (35,8,43,15,TRUE,185.36,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (36,6,47,16,TRUE,13.18,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (37,30,33,30,TRUE,186.86,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (38,12,28,11,TRUE,188.35,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (39,8,25,24,FALSE,41.37,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (40,29,4,10,TRUE,22.21,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (41,19,49,18,FALSE,63.36,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (42,29,49,26,TRUE,69.57,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (43,26,5,16,TRUE,56.7,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (44,12,14,8,FALSE,160.59,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (45,36,1,21,FALSE,139.39,FALSE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (46,32,21,5,FALSE,72.82,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (47,29,14,23,FALSE,148.04,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (48,9,33,21,TRUE,58.19,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (49,2,42,25,TRUE,106.2,TRUE);
INSERT INTO Tickets (ticketId, eventId, seatId, userId, vip, price, sold) VALUES (50,24,4,10,TRUE,146.22,TRUE);

-- Transactions data 
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (1,3,14,32,'2021-08-11 00:18:27', 50.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (2,1,7,30,'2021-03-18 05:08:43', 75.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (3,4,1,43,'2023-06-20 23:13:19', 120.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (4,6,3,17,'2021-07-10 03:56:52', 90.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (5,21,21,14,'2021-08-05 12:22:08', 60.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (6,2,19,25,'2021-10-29 03:39:34', 45.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (7,2,16,38,'2021-02-13 10:36:05', 80.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (8,7,18,1,'2023-11-25 07:38:29', 100.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (9,5,29,22,'2021-01-29 02:47:25', 70.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (10,11,27,40,'2021-04-26 15:12:35', 110.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (11,25,17,5,'2021-10-25 20:00:47', 95.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (12,11,13,44,'2022-05-19 19:44:41', 150.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (13,20,7,5,'2022-12-25 06:45:09', 65.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (14,20,3,42,'2021-01-05 11:40:24', 85.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (15,23,8,8,'2022-01-30 21:58:02', 120.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (16,8,20,26,'2021-10-16 10:30:31', 55.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (17,26,22,50,'2021-02-16 11:55:00', 130.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (18,9,17,13,'2022-06-05 12:55:43', 75.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (19,8,9,17,'2022-12-29 01:06:19', 110.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (20,23,24,32,'2022-11-15 12:37:43', 95.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (21,8,2,4,'2022-09-23 06:30:44', 70.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (22,18,3,27,'2021-10-10 17:09:18', 60.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (23,5,23,19,'2023-05-04 14:52:00', 100.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (24,26,17,36,'2022-05-02 07:04:02', 80.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (25,23,27,5,'2022-05-17 22:35:22', 65.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (26,14,5,24,'2023-01-03 09:22:56', 110.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (27,12,3,2,'2023-05-31 11:55:14', 75.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (28,28,27,20,'2023-01-21 08:36:22', 90.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (29,11,7,42,'2023-08-14 10:56:35', 120.00);
INSERT INTO Transactions (transactionId, sellerId, buyerId, ticketId, date, price) VALUES (30,9,3,38,'2022-09-26 03:55:36', 55.00);