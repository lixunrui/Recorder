-- record.sql
-- This script creates the database table for the record application

-- drop all tables first
DROP TABLE IF EXISTS Booker;
DROP TABLE IF EXISTS Record;
DROP TABLE IF EXISTS Items;
DROP TABLE IF EXISTS Status;

CREATE TABLE Booker (
	bookerID 	INTEGER PRIMARY KEY,  	-- unique id for this record
	name 		TEXT, 					-- booker's name
	address 	TEXT,					-- address
	contactNum 	TEXT					-- contact number
);

CREATE TABLE Record (
	id 			INTEGER PRIMARY KEY,  	-- unique id for this record
	bookerID 	INTEGER,			  	-- unique id for this record
	itemID		INTEGER,				-- item ID
	quantity 	INTEGER,				-- number required
	statusID	INTEGER,				-- deliver status
	sellPrice	REAL,				-- unit price
	freeDelivery BLOB,					-- TRUE: we pay the delivery fee
	timestamp	TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Items (
	itemID			INTEGER PRIMARY KEY,-- item id
	purchasePrice 	REAL,				-- purchasing price as float
	name			TEXT				-- product name		
);

CREATE TABLE Status (
	statusID INTEGER PRIMARY KEY, 		-- status id
	description TEXT					-- description
);

INSERT INTO Booker values (1, 'tester', 'address', '022');
INSERT INTO Record (id, bookerID, itemID, quantity, statusID, sellprice, freeDelivery) values (1, 1, 1, 1, 1, 0.98, 0 );
INSERT INTO Items values (1, 0.95, 'test item');


-- http://www.appcoda.com/sqlite-database-ios-app-tutorial/

-- select booker.name, items.name, record.quantity, Status.description from booker, record, items,Status where booker.bookerID = record.bookerID and record.itemID = items.itemID and record.statusID = status.statusID;

INSERT INTO Status VALUES (
	1,
    'Query'
);
INSERT INTO Status VALUES (
	2,
    'Ordered, unpaid'
);
INSERT INTO Status VALUES (
    3,
    'Ordered, paid'
);
INSERT INTO Status VALUES (
    4,
    'Delivering'
);
INSERT INTO Status VALUES (
    5,
    'Delivered'
);