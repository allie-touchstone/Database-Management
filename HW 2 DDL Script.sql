-----------------------------------------------------------------------------------------------------------------
/*

INTRO TO DATA MANAGEMENT
HOMEWORK 2: DDL SCRIPT ASSIGNMENT

by
Abhinav Sharma      ass2575
Allie Touchstone    awt529
Aritra Chowdhury    ac79277
Avery Shepherd      ams9694
Harsh Mehta         hdm564
Vishal Gupta        vg22846

This Homework was worked on by all 6 people and the best combination of code was ultimately decided on. 

*/
-----------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------
-- DROP INDEXES / SEQUENCES / TABLES SECTION
-- Authors: Abhinav Sharma (ass2575), Harsh Mehta (hdm564), Avery Shepherd (vg22846)
-----------------------------------------------------------------------------------------------------------------

-- Dropping of all Indexes
DROP INDEX Customer_Name_ix;
DROP INDEX Customer_Payment_Customer_ID_ix;
DROP INDEX Reservation_Customer_ID_ix;
DROP INDEX Room_Customer_ID_ix;
DROP INDEX Room_Floor_Room_Number_ix;

-- Dropping of all Sequences
DROP SEQUENCE Features_seq;
DROP SEQUENCE Room_seq;
DROP SEQUENCE Location_seq;
DROP SEQUENCE Reservation_seq;
DROP SEQUENCE Customer_Payment_seq;
DROP SEQUENCE Customer_seq;

-- Dropping of all Tables
DROP TABLE Location_Features_Linking;
DROP TABLE Reservation_Details;
DROP TABLE Features;
DROP TABLE Room;
DROP TABLE Location;
DROP TABLE Reservation;
DROP TABLE Customer_Payment;
DROP TABLE Customer;

-----------------------------------------------------------------------------------------------------------------
-- CREATE SEQUENCE / TABLES SECTION
-- Authors: Abhinav Sharma (ass2575), Harsh Mehta (hdm564), Avery Shepherd (vg22846)
-----------------------------------------------------------------------------------------------------------------

-- Creation of Customer Sequence
CREATE SEQUENCE Customer_seq
START WITH 100001;

-- Creation of Customer Table
CREATE TABLE Customer
(
    Customer_ID             NUMBER          DEFAULT Customer_seq.NEXTVAL    PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    First_Name              VARCHAR(50)     NOT NULL,
    Last_Name               VARCHAR(50)     NOT NULL,    
    Email                   VARCHAR(50)     NOT NULL            UNIQUE,
    Phone                   CHAR(12)        NOT NULL,
    Address_Line_1          VARCHAR(50)     NOT NULL,
    Address_Line_2          VARCHAR(50),
    City                    VARCHAR(50)     NOT NULL,   
    State                   CHAR(2)         NOT NULL,
    Zip                     CHAR(5)         NOT NULL,
    Birthdate               DATE,
    Stay_Credits_Earned     NUMBER          DEFAULT 0           NOT NULL,
    Stay_Credits_Used       NUMBER          DEFAULT 0           NOT NULL,
    CONSTRAINT stay_credits_check
        CHECK (Stay_Credits_Used <= Stay_Credits_Earned),
    CONSTRAINT email_length_check
        CHECK (LENGTH(Email) >= 7)
);

-- Creation of Customer_Payment Sequence
CREATE SEQUENCE Customer_Payment_seq;

-- Creation of Customer_Payment Table
CREATE TABLE Customer_Payment
(
    Payment_ID              NUMBER          DEFAULT Customer_Payment_seq.NEXTVAL    PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    Customer_ID             NUMBER          NOT NULL,
    Cardholder_First_Name   VARCHAR(50)     NOT NULL,
    Cardholder_Mid_Name     VARCHAR(50)     NOT NULL,
    Cardholder_Last_Name    VARCHAR(50)     NOT NULL,
    CardType                CHAR(4)         NOT NULL,
    CardNumber              VARCHAR(19)     NOT NULL,
    Expiration_Date         DATE            NOT NULL,
    CC_ID                   VARCHAR(5)      NOT NULL,
    Billing_Address         VARCHAR(50)     NOT NULL,
    Billing_City            VARCHAR(50)     NOT NULL,
    Billing_State           CHAR(2)         NOT NULL,
    Billing_Zip             CHAR(5)         NOT NULL,
    CONSTRAINT payment_fk_customers 
        FOREIGN KEY (Customer_ID) 
        REFERENCES  Customer (Customer_ID)
        ON DELETE CASCADE
);

-- Creation of Reservation Sequence
CREATE SEQUENCE Reservation_seq;

-- Creation of Reservation Table
CREATE TABLE Reservation
(
    Reservation_ID          NUMBER          DEFAULT Reservation_seq.NEXTVAL     PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    Customer_ID             NUMBER          NOT NULL,
    Confirmation_Nbr        CHAR(8)         NOT NULL            UNIQUE,
    Date_Created            DATE            DEFAULT SYSDATE     NOT NULL,
    Check_In_Date           DATE            NOT NULL,
    Check_Out_Date          DATE,
    Status                  CHAR(1)         NOT NULL,
    Discount_Code           VARCHAR(50),
    Reservation_Total       NUMBER          NOT NULL,
    Customer_Rating         NUMBER,
    Notes                   VARCHAR(500),
    CONSTRAINT reservation_fk_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES  Customer (Customer_ID)
        ON DELETE CASCADE,
    CONSTRAINT status_check
        CHECK (Status IN ('U', 'I', 'C', 'N', 'R'))
);

-- Creation of Location Sequence
CREATE SEQUENCE Location_seq;

-- Creation of Location Table
CREATE TABLE Location
(
    Location_ID             NUMBER          DEFAULT Location_seq.NEXTVAL    PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    Location_Name           VARCHAR(50)     NOT NULL            UNIQUE,
    Address                 VARCHAR(50)     NOT NULL,
    City                    VARCHAR(50)     NOT NULL,
    State                   CHAR(2)         NOT NULL,
    Zip                     CHAR(5)         NOT NULL,               
    Phone                   CHAR(12)        NOT NULL,
    URL                     VARCHAR(50)     NOT NULL
);

-- Creation of Room Sequence
CREATE SEQUENCE Room_seq;

-- Creation of Room Table
CREATE TABLE Room
(
    Room_ID                 NUMBER          DEFAULT Room_seq.NEXTVAL    PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    Location_ID             NUMBER          NOT NULL,
    Floor                   VARCHAR(50)     NOT NULL,
    Room_Number             VARCHAR(50)     NOT NULL,
    Room_Type               CHAR(1)         NOT NULL,
    Square_Footage          NUMBER          NOT NULL,
    Max_People              NUMBER          NOT NULL,            
    Weekday_Rate            NUMBER          NOT NULL,
    Weekend_Rate            NUMBER          NOT NULL,
    CONSTRAINT room_fk_location
        FOREIGN KEY (Location_ID)
        REFERENCES  Location (Location_ID)
        ON DELETE CASCADE,
    CONSTRAINT room_type_check
        CHECK (Room_Type IN ('D', 'Q', 'K', 'S', 'C'))
);

-- Creation of Features Sequence
CREATE SEQUENCE Features_seq;

-- Creation of Features Table
CREATE TABLE Features
(
    Feature_ID              NUMBER          DEFAULT Features_seq.NEXTVAL    PRIMARY KEY, -- Primary Keys are by default Unique and Not Null
    Feature_Name            VARCHAR(50)     NOT NULL            UNIQUE
);

-- Creation of Reservation_Details Table
CREATE TABLE Reservation_Details
(
    Reservation_ID          NUMBER,
    Room_ID                 NUMBER,
    Number_of_Guests        NUMBER          NOT NULL,
    CONSTRAINT reservation_room_pk   
        PRIMARY KEY (Reservation_ID, Room_ID), -- Primary Keys are by default Unique and Not Null
    CONSTRAINT details_fk_reservation
        FOREIGN KEY (Reservation_ID)
        REFERENCES  Reservation (Reservation_ID)
        ON DELETE CASCADE,
    CONSTRAINT details_fk_room
        FOREIGN KEY (Room_ID)
        REFERENCES  Room (Room_ID)
        ON DELETE CASCADE
);

-- Creation of Location_Features_Linking Table
CREATE TABLE Location_Features_Linking
(
    Location_ID             NUMBER,
    Feature_ID              NUMBER,
    CONSTRAINT location_features_pk      
        PRIMARY KEY (Location_ID, Feature_ID), -- Primary Keys are by default Unique and Not Null
    CONSTRAINT linking_fk_location
        FOREIGN KEY (Location_ID)
        REFERENCES  Location (Location_ID)
        ON DELETE CASCADE,
    CONSTRAINT linking_fk_feature
        FOREIGN KEY (Feature_ID)
        REFERENCES  Features (Feature_ID)
        ON DELETE CASCADE
);

-----------------------------------------------------------------------------------------------------------------
-- INSERT DATA SECTION
-- Authors: Allie Touchstone (awt529), Aritra Chowdhury (ac79299), Vishal Gupta (vg22846)
-----------------------------------------------------------------------------------------------------------------

-- Insertion into Location Table
-- Creation of the 3 Locations mentioned in HW1
INSERT INTO Location
VALUES
    (DEFAULT, 'South Congress', '1600 S Congress Ave', 'Austin', 'TX', '78704', '512-123-456', 'www.southcongresshotel.com');
 
INSERT INTO Location 
VALUES
    (DEFAULT, 'The East 7th Lofts', '1050 E 7th St', 'Austin', 'TX', '78702', '512-987-654', 'www.east7thlofts.com');

INSERT INTO Location
VALUES
    (DEFAULT, 'Balcones Canyonlands', '100 Ranch Rd', 'Marble Falls', 'TX', '78654', '737-789-321', 'www.balconescanyonlands.com');

COMMIT;

-- Insertion into Features Table
-- Creation of 3 Features
INSERT INTO Features
VALUES
    (DEFAULT, 'Free Wi-Fi');

INSERT INTO Features
VALUES
    (DEFAULT, 'Free Breakfast');

INSERT INTO Features
VALUES
    (DEFAULT, 'Health Center');

COMMIT;

-- Insertion into Location_Features_Linking Table
-- Location 1 has 1 Feature
-- Location 2 has 2 Features
-- Location 3 has 3 Features
INSERT INTO Location_Features_Linking
VALUES
    (1, 1);

INSERT INTO Location_Features_Linking
VALUES
    (2, 2);

INSERT INTO Location_Features_Linking
VALUES
    (2, 3);

INSERT INTO Location_Features_Linking
VALUES
    (3, 1);

INSERT INTO Location_Features_Linking
VALUES
    (3, 2);

INSERT INTO Location_Features_Linking
VALUES
    (3, 3);
    
COMMIT;

-- Insertion into Room Table
-- Creation of 2 Rooms for each Location
INSERT INTO Room
VALUES
    (DEFAULT, 1, 1, 100, 'D', 800, 2, 100, 150);
    
INSERT INTO Room
VALUES
    (DEFAULT, 1, 2, 200, 'K', 1400, 3, 150, 200);

INSERT INTO Room
VALUES
    (DEFAULT, 2, 1, 10, 'Q', 1500, 2, 150, 200);

INSERT INTO Room
VALUES
    (DEFAULT, 2, 2, 20, 'S', 3500, 4, 400, 500);

INSERT INTO Room
VALUES
    (DEFAULT, 3, 1, 100, 'Q', 1200, 2, 150, 200);

INSERT INTO Room
VALUES
    (DEFAULT, 3, 2, 200, 'C', 1000, 2, 150, 200);

COMMIT;

-- Insertion into Customers Table
INSERT INTO Customer
VALUES
    (DEFAULT, 'Allie', 'Touchstone', 'awt529@utexas.edu', '737-895-2576', '420', 'W 21st St', 'Austin', 'TX', '78721', NULL, DEFAULT, DEFAULT);

INSERT INTO Customer
VALUES
    (DEFAULT, 'Thomas', 'Anderson', 'neotheone@gmail.com', '737-123-456', 'Central West', '22nd St', 'Austin', 'TX', '78701', '13-SEP-71', DEFAULT, DEFAULT);

-- Insertion into Customer_Payment Table
-- Attachment of Payments to Customers
INSERT INTO Customer_Payment
VALUES
    (DEFAULT, 100001, 'Allie', 'White', 'Touchstone', 'VISA', 123456789012, '01-JAN-25', 100, '420 W 21st St', 'Austin', 'TX', '78721');

INSERT INTO Customer_Payment
VALUES
    (DEFAULT, 100002, 'Thomas', 'A', 'Anderson', 'VISA', 567890123456, '31-JAN-24', 900, 'West Central St', 'Austin', 'TX', '78701');

-- Insertion into Reservation Table
-- I (Customer 1) book Room 1 (Location 1) for 1 day (weekend)
-- The Unknown Customer (Customer 2) books Room 4 (Location 2) for 1 day (weekend) as the First Reservation. 
-- The Unknown Customer (Customer 2) books Rooms 5 and 6 (Location 3) for 3 days (weekdays) as the Second Reservation. 
INSERT INTO Reservation
VALUES
    (DEFAULT, 100001, 'ABCD1000', DEFAULT, '09-OCT-21', '10-OCT-21', 'C', 'UT2022', 150, NULL, NULL);

INSERT INTO Reservation
VALUES
    (DEFAULT, 100002, 'ABCD1001', DEFAULT, '09-OCT-21', '10-OCT-21', 'C', NULL, 500, NULL, NULL);

INSERT INTO Reservation
VALUES
    (DEFAULT, 100002, 'ABCD1002', DEFAULT, '11-OCT-21', '14-OCT-21', 'C', NULL, 1200, NULL, NULL);

-- Insertion into Reservation_Details Table
-- Booking of Rooms for respective Reservations
INSERT INTO Reservation_Details
VALUES
    (1, 1, 2);

INSERT INTO Reservation_Details
VALUES
    (2, 4, 4);

INSERT INTO Reservation_Details
VALUES
    (3, 5, 2);

INSERT INTO Reservation_Details
VALUES
    (3, 6, 1);

-----------------------------------------------------------------------------------------------------------------
-- CREATE INDEX SECTION
-- Authors: Allie Touchstone (awt529), Aritra Chowdhury (ac79299), Vishal Gupta (vg22846)
-----------------------------------------------------------------------------------------------------------------

-- Creation of Index on First_Name and Last_Name Columns of Customer Table
CREATE INDEX Customer_Name_ix
    ON Customer (First_Name, Last_Name); 

-- Creation of Index on Foreign Key of Customer_Payment Table
CREATE INDEX Customer_Payment_Customer_ID_ix
    ON Customer_Payment (Customer_ID); 
    
-- Creation of Index on Foreign Key of Reservation Table
CREATE INDEX Reservation_Customer_ID_ix
    ON Reservation (Customer_ID); 

-- Creation of Index on Foreign Key of Room Table
CREATE INDEX Room_Customer_ID_ix
    ON Room (Location_ID);

-- Creation of Index on Floor and Room_Number Columns of Room Table
CREATE INDEX Room_Floor_Room_Number_ix
    ON Room (Floor, Room_Number); 
