-- Use a specific database or create a new one



-- Step 1: Drop all foreign key constraints
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' +
               QUOTENAME(OBJECT_NAME(parent_object_id)) +
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

EXEC sp_executesql @sql;



-- Drop tables in reverse order of dependencies if they exist, for clean recreation
DROP TABLE IF EXISTS BookedSeats;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS PaymentPartner; 
DROP TABLE IF EXISTS BookingDiscounts;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Seatinventory;
DROP TABLE IF EXISTS Shows;
DROP TABLE IF EXISTS Seats;
DROP TABLE IF EXISTS SeatTypes;
DROP TABLE IF EXISTS Screens;
DROP TABLE IF EXISTS Seatlayots;
DROP TABLE IF EXISTS Venues;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Currency;
DROP TABLE IF EXISTS Translations; 
DROP TABLE IF EXISTS TranslationEntity;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS discount_types;
DROP TABLE IF EXISTS show_discounts;
DROP TABLE IF EXISTS payment_discounts;


-- GO


CREATE TABLE languages (
    language_id INT PRIMARY KEY,
    language_code VARCHAR(10) UNIQUE NOT NULL, -- e.g., 'en', 'hi', 'ta'
    language_name VARCHAR(50) NOT NULL,
    parent_language_id INT,
    is_active BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0 NOT NULL, -- 0 for false, 1 for true
    created_by NVARCHAR(100), -- user or service name
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100), -- user or service name
    updated_at DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE TranslationEntity (
   entitytype_id INT PRIMARY KEY,
    Name NVARCHAR(100) , -- e.g., "DB FIeld, UI Label"
    Scope NVARCHAR(255), -- Global, Common, Page 
	is_active BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0 NOT NULL, -- 0 for false, 1 for true
    created_by NVARCHAR(100), -- user or service name
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100), -- user or service name
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO


CREATE TABLE Translations (
    translation_id BIGINT PRIMARY KEY,
	versionno INT NOT NULL,
    entitytype_id INT NOT NULL, -- 'DB FIeld', 'Message', 'ui_label'
    entity_id NVARCHAR(100), -- ID of the related entity (movie_id, or label_id)
    language_id INT REFERENCES languages(language_id),
    baseText NVARCHAR(4000) NOT NULL, -- 'title', 'description', 'label'
    translated_text NVARCHAR(4000) NOT NULL,
	is_active BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0 NOT NULL, -- 0 for false, 1 for true
    created_by NVARCHAR(100), -- user or service name
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100), -- user or service name
    updated_at DATETIME2 DEFAULT GETDATE()

);
GO



CREATE TABLE Currency (
    currency_code CHAR(3) PRIMARY KEY,  -- e.g., 'USD', 'INR'
    currancy_name VARCHAR(50) NOT NULL,
    symbol NVARCHAR(5) NOT NULL,  -- e.g., '$', '₹'
    is_active BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0 NOT NULL, -- 0 for false, 1 for true
    created_by NVARCHAR(100), -- user or service name
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100), -- user or service name
    updated_at DATETIME2 DEFAULT GETDATE()
);


CREATE TABLE Users (
    user_id BIGINT  PRIMARY KEY,
    username NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) UNIQUE NOT NULL,
    mobile NVARCHAR(20),
    DisplayName NVARCHAR(100),
    is_deleted BIT DEFAULT 0 NOT NULL, -- 0 for false, 1 for true
    created_by NVARCHAR(100), -- user or service name
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100), -- user or service name
    updated_at DATETIME2 DEFAULT GETDATE()
    
);
GO

CREATE TABLE Cities (
    city_id INT PRIMARY KEY,
    city_name NVARCHAR(100) UNIQUE NOT NULL,
    state NVARCHAR(100),
    country NVARCHAR(100),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    parent_category_id INT REFERENCES Categories(category_id),
    icon_url NVARCHAR(255),
    categoriesdescription NVARCHAR(255),
    is_active BIT DEFAULT 1,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE Addresses (
    addressid BIGINT PRIMARY KEY,
    addressline1 NVARCHAR(255),
    addressline2 NVARCHAR(255),
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
    );
GO


CREATE TABLE Venues (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(255) NOT NULL,
    addressid BIGINT  REFERENCES addresses(addressid),
    contact_email NVARCHAR(255),
    contact_phone NVARCHAR(20),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO


CREATE TABLE Screens (
    screen_id INT PRIMARY KEY,
    venue_id INT NOT NULL, 
    screen_name NVARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    seatlayot_id INT,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE Seatlayots (
    seatlayot_id INT PRIMARY KEY,
    maxrows INT NOT NULL,
    maxcolums INT NOT NULL,
    laysotJson NVARCHAR(4000),
    layotimageurl NVARCHAR(255),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    language NVARCHAR(50),
    release_date DATE,
    duration_minutes INT,
    director NVARCHAR(255),
    casts NVARCHAR(MAX), -- Store as comma-separated string or JSON if complex
    description NVARCHAR(MAX),
    rating DECIMAL(2,1), -- e.g., 8.5
    poster_url NVARCHAR(500),
    trailer_url NVARCHAR(500),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 6. SeatTypes Table
CREATE TABLE SeatTypes (
    seat_type_id INT PRIMARY KEY,
    type_name NVARCHAR(50) UNIQUE NOT NULL, -- e.g., 'Standard', 'Premium', 'VIP'
    facility NVARCHAR(255),
    price_multiplier DECIMAL(3,2) NOT NULL DEFAULT 1.0, -- e.g., 1.0 for standard, 1.2 for premium
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 7. Seats Table
CREATE TABLE Seats (
    seat_id BIGINT PRIMARY KEY,
    screen_id INT NOT NULL, -- FK to Screens.screen_id
    row_number NVARCHAR(10),
    seat_number NVARCHAR(10) NOT NULL, -- e.g., 'A1', 'B5'
    seat_type_id INT NOT NULL, -- FK to SeatTypes.seat_type_id
    currency_code CHAR(3),
    seat_price DECIMAL(10,2) NOT NULL,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
    -- Unique constraint for seat within a screen
    -- Will be added after all tables exist to allow FK references
    -- ALTER TABLE Seats ADD CONSTRAINT UQ_Screen_Seat UNIQUE (screen_id, row_number, seat_number);
);
GO

-- 8. Shows Table
CREATE TABLE Shows (
    show_id BIGINT PRIMARY KEY,
    movie_id INT NOT NULL, -- FK to Movies.movie_id
    screen_id INT NOT NULL, -- FK to Screens.screen_id
    start_datetime DATETIME2 NOT NULL,
    end_datetime DATETIME2 NOT NULL,
    currency_code CHAR(3),
    baseticket_price DECIMAL(10,2) NOT NULL,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO


CREATE TABLE Seatinventory (
    seatinventory_id BIGINT PRIMARY KEY,
    seat_id BIGINT NOT NULL REFERENCES seats(seat_id),
    show_id BIGINT NOT NULL REFERENCES shows(show_id),
    currency_code CHAR(3),
    price DECIMAL(10,2) NOT NULL,
    lockedforuser NVARCHAR(100) , --user_id
    lock_time DATETIME2 ,
    expiry_time DATETIME2,
	is_locked BIT DEFAULT 0,
    is_booked BIT DEFAULT 0,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE discount_types (
    discount_type_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, -- "Early Bird", "Weekend Special"
    calculation_type VARCHAR(10) CHECK (calculation_type IN ('percentage', 'fixed')),
	is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- Show-specific discounts (e.g., 20% off afternoon shows)
CREATE TABLE show_discounts (
    discount_id BIGINT PRIMARY KEY,
    show_id BIGINT REFERENCES shows(show_id) ON DELETE CASCADE,
    discount_type_id INT REFERENCES discount_types(discount_type_id),
    discount_value DECIMAL(5,2) NOT NULL, -- 15.00 or 0.15
    valid_until DATETIME2,
    max_uses INT,
    current_uses INT DEFAULT 0,
	is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- Payment method discounts (e.g., ₹50 off using PayTM)
CREATE TABLE payment_discounts (
    paydiscount_id BIGINT PRIMARY KEY,
    discount_type_id INT REFERENCES discount_types(discount_type_id),
    payment_method VARCHAR(50) NOT NULL, -- "paytm", "credit_card"
    discount_value DECIMAL(5,2) NOT NULL,
    valid_until DATETIME2,
    min_order_amount DECIMAL(10,2) DEFAULT 0,
	is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);



-- 9. Bookings Table
CREATE TABLE Bookings (
    booking_id BIGINT  PRIMARY KEY,
    user_id NVARCHAR(255), 
    show_id BIGINT NOT NULL, -- FK to Shows.show_id
    booking_time DATETIME2 DEFAULT GETDATE() NOT NULL, -- Explicit booking time
    currency_code CHAR(3),
    total_amount DECIMAL(10,2) NOT NULL, 
	discount_amount DECIMAL(10,2),
    net_amount DECIMAL(10,2) NOT NULL,
    booking_status_code NVARCHAR(50) NOT NULL, -- 'Confirmed', 'Cancelled', 'Reserved'
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 10. BookedSeats Table (Junction table for Booking and Seats)
CREATE TABLE BookedSeats (
    booking_seat_id BIGINT PRIMARY KEY,
    booking_id BIGINT NOT NULL, -- FK to Bookings.booking_id
    seat_id BIGINT NOT NULL, -- FK to Seats.seat_id
    currency_code CHAR(3),
    seat_price DECIMAL(10,2) NOT NULL,
    statuscode NVARCHAR(50) NOT NULL, -- 'Booked', 'Reserved', 'Cancelled'
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE BookingDiscounts (
    booking_discount_id BIGINT PRIMARY KEY,
    booking_id BIGINT NOT NULL, -- FK to Bookings.booking_id
	discount_id BIGINT,  -- FK to Discount.discount_id
    currency_code CHAR(3),
    discount_price DECIMAL(10,2) NOT NULL,
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO
-- 11. Paymentpartner Table
CREATE TABLE Paymentpartner (
    partner_id BIGINT PRIMARY KEY,
    partner_name NVARCHAR(100), -- FK to Bookings.booking_id
    base_url NVARCHAR(500),
    api_key_alias NVARCHAR(255),
    notes NVARCHAR(255),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 12. Payments Table
CREATE TABLE Payments (
    payment_id BIGINT PRIMARY KEY,
    booking_id BIGINT NOT NULL, -- FK to Bookings.booking_id
    paymentpartner_id int,
    currency_code CHAR(3),
    amount DECIMAL(10,2) NOT NULL,
    payment_method_code NVARCHAR(50) NOT NULL, -- 'Credit Card', 'UPI', 'Net Banking'
    transaction_date DATETIME2 DEFAULT GETDATE() NOT NULL,
    payment_statuscode NVARCHAR(50) NOT NULL, -- 'Success', 'Failed', 'Pending'
    payment_transaction_id NVARCHAR(255), -- Reference to external payment gateway ID
    notes NVARCHAR(255),
    is_deleted BIT DEFAULT 0, 
    created_by NVARCHAR(100), 
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_by NVARCHAR(100),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO






-- Add all Foreign Key Constraints after tables are created
-- This prevents issues with circular dependencies

ALTER TABLE Seats
ADD CONSTRAINT UQ_Screen_Seat UNIQUE (screen_id, row_number, seat_number); -- Unique seat within a screen


ALTER TABLE BookedSeats
ADD CONSTRAINT UQ_Booking_Seat_Show UNIQUE (booking_id, seat_id); -- A seat can only be booked once per booking

ALTER TABLE Payments
ADD CONSTRAINT FK_Payments_Booking FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id);




GO


---------------Meta Data and Sample Data 


Begin Tran

INSERT INTO Currency (currency_code, currancy_name, symbol, created_by, updated_by)
VALUES 
('USD', 'US Dollar', '$', 'system', 'system'),
('INR', 'Indian Rupee', '₹', 'system', 'system'),
('EUR', 'Euro', '€', 'system', 'system'),
('GBP', 'British Pound', '£', 'system', 'system');


INSERT INTO languages (language_id, language_code, language_name, parent_language_id, is_active, created_by, updated_by)
VALUES 
(1, 'en', 'English', NULL, 1, 'system', 'system'),
(2, 'hi', 'Hindi', NULL, 1, 'system', 'system'),
(3, 'ta', 'Tamil', NULL, 1, 'system', 'system'),
(4, 'te', 'Telugu', NULL, 1, 'system', 'system'),
(5, 'kn', 'Kannada', NULL, 1, 'system', 'system');



INSERT INTO TranslationEntity (entitytype_id, Name, Scope, is_active, created_by, updated_by)
VALUES 
(1, 'Movie Title', 'Global', 1, 'system', 'system'),
(2, 'Movie Description', 'Global', 1, 'system', 'system'),
(3, 'Screen Name', 'Venue', 1, 'system', 'system'),
(4, 'Seat Type', 'Global', 1, 'system', 'system'),
(5, 'UI Label', 'Common', 1, 'system', 'system');





INSERT INTO Translations (translation_id, versionno, entitytype_id, entity_id, language_id, baseText, translated_text, created_by, updated_by)
VALUES 
(1, 1, 1, '101', 2, 'Avatar', 'अवतार', 'system', 'system'),
(2, 1, 1, '101', 3, 'Avatar', 'அவதார்', 'system', 'system'),
(3, 1, 2, '101', 2, 'A science fiction film', 'एक विज्ञान कथा चित्रपट', 'system', 'system'),
(4, 1, 5, 'BOOK_NOW', 2, 'Book Now', 'अभी बुक करें', 'system', 'system'),
(5, 1, 5, 'BOOK_NOW', 3, 'Book Now', 'இப்போதே பதிவு செய்யவும்', 'system', 'system');



INSERT INTO Users (user_id, username, password_hash, email, mobile, DisplayName, created_by, updated_by)
VALUES 
(1, 'Ajay', 'hashed_password_1', 'ajay@example.com', '9876543210', 'John Doe', 'system', 'system'),
(2, 'jane_smith', 'hashed_password_2', 'jane@example.com', '8765432109', 'Jane Smith', 'system', 'system'),
(3, 'admin', 'hashed_admin_password', 'admin@xyz.com', '9123456780', 'Administrator', 'system', 'system');


INSERT INTO Cities (city_id, city_name, state, country, created_by, updated_by)
VALUES 
(1, 'Mumbai', 'Maharashtra', 'India', 'system', 'system'),
(2, 'Delhi', 'Delhi', 'India', 'system', 'system'),
(3, 'Bangalore', 'Karnataka', 'India', 'system', 'system'),
(4, 'Chennai', 'Tamil Nadu', 'India', 'system', 'system'),
(5, 'Hyderabad', 'Telangana', 'India', 'system', 'system');


INSERT INTO Categories (category_id, parent_category_id, categoriesdescription, created_by, updated_by)
VALUES 
(1, NULL, 'Movies', 'system', 'system'),
(2, NULL, 'Events', 'system', 'system'),
(3, 1, 'Bollywood', 'system', 'system'),
(4, 1, 'Hollywood', 'system', 'system'),
(5, 2, 'Concerts', 'system', 'system');


INSERT INTO Addresses (addressid, addressline1, addressline2, city, postal_code, latitude, longitude, created_by, updated_by)
VALUES 
(1, '123 Cinema Street', 'Andheri West', 'Mumbai', '400053', 19.1364, 72.8296, 'system', 'system'),
(2, '45 Movie Plaza', 'MG Road', 'Bangalore', '560001', 12.9716, 77.5946, 'system', 'system'),
(3, '78 Film Nagar', 'Jubilee Hills', 'Hyderabad', '500033', 17.4332, 78.4011, 'system', 'system'),
(4, '12 Andheri Street', 'Andheri East', 'Mumbai', '400070', 19.8364, 72.6596, 'system', 'system');


INSERT INTO Venues (venue_id, venue_name, addressid, contact_phone, created_by, updated_by)
VALUES 
(1, 'PVR Cinemas - Andheri', 1, '022-12345678', 'system', 'system'),
(2, 'INOX - MG Road', 2, '080-87654321', 'system', 'system'),
(3, 'Prasad', 3, '040-98765432', 'system', 'system'),
(4, 'Big Cinemas', 4, '022-18345678', 'system', 'system');


INSERT INTO Seatlayots (seatlayot_id, maxrows, maxcolums, laysotJson, created_by, updated_by)
VALUES 
(1, 10, 15, '{"rows":10,"columns":15,"premiumRows":[1,2]}', 'system', 'system'),
(2, 12, 20, '{"rows":12,"columns":20,"vipRows":[1]}', 'system', 'system'),
(3, 8, 12, '{"rows":8,"columns":12}', 'system', 'system'),
(4, 8, 10, '{"rows":8,"columns":10}', 'system', 'system');

INSERT INTO Screens (screen_id, venue_id, screen_name, capacity, seatlayot_id, created_by, updated_by)
VALUES 
(1, 1, 'Screen 1', 150, 1, 'system', 'system'),
(2, 1, 'Screen 2', 240, 2, 'system', 'system'),
(3, 2, 'Main Screen', 96, 3, 'system', 'system'),
(4, 3, 'Main Screen', 96, 3, 'system', 'system'),
(5, 3, 'Big Screen', 80, 4, 'system', 'system');

INSERT INTO Movies (movie_id, title, language, release_date, duration_minutes, director, casts, description, rating, poster_url, created_by, updated_by)
VALUES 
(101, 'Avatar', 'English', '2023-12-15', 192, 'James Cameron', 'Sam Worthington, Zoe Saldana', 'A science fiction film', 8.5, 'https://example.com/posters/avatar.jpg', 'system', 'system'),
(102, 'RRR', 'Hindi', '2022-03-25', 182, 'S. S. Rajamouli', 'N. T. Rama Rao Jr., Ram Charan', 'Period action drama film', 9.0, 'https://example.com/posters/rrr.jpg', 'system', 'system'),
(103, 'Pathaan', 'Hindi', '2023-01-25', 146, 'Siddharth Anand', 'Shah Rukh Khan, Deepika Padukone', 'Action thriller film', 7.8, 'https://example.com/posters/pathaan.jpg', 'system', 'system'),
(104, 'RRR', 'Telugu', '2022-03-25', 182, 'S. S. Rajamouli', 'N. T. Rama Rao Jr., Ram Charan', 'Period action drama film', 9.0, 'https://example.com/posters/rrr.jpg', 'system', 'system');


INSERT INTO SeatTypes (seat_type_id, type_name, facility, price_multiplier, created_by, updated_by)
VALUES 
(1, 'Standard', 'Regular seat', 1.0, 'system', 'system'),
(2, 'Premium', 'Extra legroom', 1.5, 'system', 'system'),
(3, 'VIP', 'Recliner seat with food service', 2.5, 'system', 'system');


-- Screen 1 seats (15 columns x 10 rows)
INSERT INTO Seats (seat_id, screen_id, row_number, seat_number, seat_type_id, currency_code, seat_price, created_by, updated_by)
SELECT 
    ROW_NUMBER() OVER (ORDER BY r, c) AS seat_id,
    1 AS screen_id,
    CHAR(64 + r) AS row_number,
    CAST(c AS VARCHAR) AS seat_number,
    CASE WHEN r <= 2 THEN 2 ELSE 1 END AS seat_type_id,
    'INR' AS currency_code,
    CASE WHEN r <= 2 THEN 300.00 ELSE 200.00 END AS seat_price,
    'system' AS created_by,
    'system' AS updated_by
FROM 
    (SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS r FROM sys.all_objects) r
    CROSS JOIN (SELECT TOP 15 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS c FROM sys.all_objects) c;


-- Screen 2 seats (20 columns x 12 rows)
INSERT INTO Seats (seat_id, screen_id, row_number, seat_number, seat_type_id, currency_code, seat_price, created_by, updated_by)
SELECT 
    150 + ROW_NUMBER() OVER (ORDER BY r, c) AS seat_id,
    2 AS screen_id,
    CHAR(64 + r) AS row_number,
    CAST(c AS VARCHAR) AS seat_number,
    CASE 
        WHEN r = 1 THEN 3 
        WHEN r <= 3 THEN 2 
        ELSE 1 
    END AS seat_type_id,
    'INR' AS currency_code,
    CASE 
        WHEN r = 1 THEN 500.00 
        WHEN r <= 3 THEN 350.00 
        ELSE 250.00 
    END AS seat_price,
    'system' AS created_by,
    'system' AS updated_by
FROM 
     (SELECT TOP 12 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS r FROM sys.all_objects) r
    CROSS JOIN (SELECT TOP 20 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS c FROM sys.all_objects) c;



-- Screen 5 seats (10 columns x 8 rows)
INSERT INTO Seats (seat_id, screen_id, row_number, seat_number, seat_type_id, currency_code, seat_price, created_by, updated_by)
SELECT 
    390+ ROW_NUMBER() OVER (ORDER BY r, c) AS seat_id,
    5 AS screen_id,
    CHAR(64 + r) AS row_number,
    CAST(c AS VARCHAR) AS seat_number,
    CASE WHEN r <= 2 THEN 2 ELSE 1 END AS seat_type_id,
    'INR' AS currency_code,
    CASE WHEN r <= 2 THEN 200.00 ELSE 150.00 END AS seat_price,
    'system' AS created_by,
    'system' AS updated_by
FROM 
    (SELECT TOP 8 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS r FROM sys.all_objects) r
    CROSS JOIN (SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS c FROM sys.all_objects) c;
	

    INSERT INTO Shows (show_id, movie_id, screen_id, start_datetime, end_datetime, currency_code, baseticket_price, created_by, updated_by)
VALUES 
(1001, 101, 1, '2025-07-20 10:00:00', '2025-07-20 13:12:00', 'INR', 200.00, 'system', 'system'),
(1002, 101, 1, '2025-07-20 14:00:00', '2025-07-20 17:12:00', 'INR', 200.00, 'system', 'system'),
(1003, 102, 2, '2025-07-20 11:30:00', '2025-07-20 14:32:00', 'INR', 250.00, 'system', 'system'),
(1004, 103, 3, '2025-07-20 18:00:00', '2025-07-20 20:26:00', 'INR', 180.00, 'system', 'system'),
(1005, 104, 5, '2025-07-20 13:00:00', '2025-07-20 15:26:00', 'INR', 180.00, 'system', 'system');

-- Insert seat inventory for show 1001
INSERT INTO Seatinventory (seatinventory_id, seat_id, show_id, currency_code, price, created_by, updated_by)
SELECT 
    ROW_NUMBER() OVER (ORDER BY s.seat_id) AS seatinventory_id,
    s.seat_id,
    1001 AS show_id,
    s.currency_code,
    s.seat_price AS price,
    'system' AS created_by,
    'system' AS updated_by
FROM Seats s
WHERE s.screen_id = 1;

-- Insert seat inventory for show 1003
INSERT INTO Seatinventory (seatinventory_id, seat_id, show_id, currency_code, price, created_by, updated_by)
SELECT 
    150 + ROW_NUMBER() OVER (ORDER BY s.seat_id) AS seatinventory_id,
    s.seat_id,
    1003 AS show_id,
    s.currency_code,
    s.seat_price AS price,
    'system' AS created_by,
    'system' AS updated_by
FROM Seats s
WHERE s.screen_id = 2;

-- Insert seat inventory for show 1005
INSERT INTO Seatinventory (seatinventory_id, seat_id, show_id, currency_code, price, created_by, updated_by)
SELECT 
    390 + ROW_NUMBER() OVER (ORDER BY s.seat_id) AS seatinventory_id,
    s.seat_id,
    1005 AS show_id,
    s.currency_code,
    s.seat_price AS price,
    'system' AS created_by,
    'system' AS updated_by
FROM Seats s
WHERE s.screen_id = 5;


-- Sample Data for discount_types
INSERT INTO discount_types (discount_type_id, name, calculation_type, created_by, updated_by) VALUES
(1, 'Early Bird', 'percentage', 'Admin', 'Admin'),
(2, 'Weekend Special', 'fixed', 'Admin', 'Admin'),
(3, 'Afternoon Offer', 'percentage', 'Admin', 'Admin'),
(4, 'Payment Gateway Discount', 'fixed', 'Admin', 'Admin');

-- Sample Data for show_discounts
INSERT INTO show_discounts (discount_id, show_id, discount_type_id, discount_value, valid_until, max_uses, current_uses, created_by, updated_by) VALUES
(101, 1001, 1, 15.00, '2025-08-31 23:59:59', 50, 15, 'Admin', 'Admin'), -- 15% off Early Bird for Show 1001
(102, 1003, 2, 50.00, '2025-07-28 23:59:59', 200, 75, 'Admin', 'Admin'), -- ₹50 off Weekend Special for Show 1003
(103, 1004, 3, 20.00, '2025-09-15 23:59:59', 30, 20, 'Admin', 'Admin'), -- 20% off Afternoon for Show 1004
(104, 1005, 3, 20.00, '2025-09-15 23:59:59', 30, 20, 'Admin', 'Admin'); -- 20% off Afternoon for Show 1005



-- Sample Data for payment_discounts
INSERT INTO payment_discounts (paydiscount_id, discount_type_id, payment_method, discount_value, valid_until, min_order_amount, created_by, updated_by) VALUES
(201, 4, 'paytm', 75.00, '2025-12-31 23:59:59', 500.00, 'Admin', 'Admin'), -- ₹75 off with PayTM for orders >= ₹500
(202, 3, 'credit_card', 5.00, '2025-10-31 23:59:59', 1000.00, 'Admin', 'Admin'), -- 5% off with Credit Card for orders >= ₹1000
(203, 4, 'upi', 25.00, '2025-09-30 23:59:59', 200.00, 'Admin', 'Admin'); -- ₹25 off with UPI for orders >= ₹200


INSERT INTO BookingDiscounts (booking_discount_id, booking_id, discount_id, currency_code, discount_price, created_by, updated_by) VALUES
(1,5001, 101,'INR' ,90.00, 'Admin', 'Admin'), 
(2,5002, 102, 'INR', 50.00, 'Admin', 'Admin'), 
(3,5003, 103, 'INR', 72, 'Admin', 'Admin'); 


INSERT INTO Bookings (booking_id, user_id, show_id, currency_code, total_amount,discount_amount,net_amount, booking_status_code, created_by, updated_by)
VALUES 
(5001, '1', 1001, 'INR', 600.00, 90.00, 510.00, 'Confirmed', 'system', 'system'),
(5002, '2', 1003, 'INR', 1000.00, 50.00, 950.00, 'Confirmed', 'system', 'system'),
(5003, '1', 1004, 'INR', 360.00, 72.00, 288.00, 'Pending', 'system', 'system');

INSERT INTO BookedSeats (booking_seat_id, booking_id, seat_id, currency_code, seat_price, statuscode, created_by, updated_by)
VALUES 
(1, 5001, 1, 'INR', 300.00, 'Booked', 'system', 'system'),
(2, 5001, 2, 'INR', 300.00, 'Booked', 'system', 'system'),
(3, 5002, 151, 'INR', 500.00, 'Booked', 'system', 'system'),
(4, 5002, 152, 'INR', 500.00, 'Booked', 'system', 'system'),
(5, 5003, 271, 'INR', 180.00, 'Reserved', 'system', 'system'),
(6, 5003, 272, 'INR', 180.00, 'Reserved', 'system', 'system');



INSERT INTO Paymentpartner (partner_id, partner_name, base_url, api_key_alias, created_by, updated_by)
VALUES 
(1, 'Razorpay', 'https://api.razorpay.com', 'razorpay_prod_key', 'system', 'system'),
(2, 'Paytm', 'https://securegw.paytm.in', 'paytm_prod_key', 'system', 'system'),
(3, 'Stripe', 'https://api.stripe.com', 'stripe_prod_key', 'system', 'system');




INSERT INTO Payments (payment_id, booking_id, paymentpartner_id, currency_code, amount, payment_method_code, payment_statuscode, payment_transaction_id, created_by, updated_by)
VALUES 
(1, 5001, 1, 'INR', 510.00, 'Credit Card', 'Success', 'pay_123456789', 'system', 'system'),
(2, 5002, 2, 'INR', 950.00, 'UPI', 'Success', 'pay_987654321', 'system', 'system'),
(3, 5002, 1, 'INR', 288.00, 'UPI', 'Success', 'pay_1212654321', 'system', 'system');



Commit;








