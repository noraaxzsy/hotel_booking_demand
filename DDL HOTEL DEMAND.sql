CREATE STOGROUP SG_HOTEL
 ON '/db2data1/db2inst', '/db2data2/db2inst'
 DATA TAG NONE;

CREATE BUFFERPOOL BP_DIM PAGESIZE 8K;
 		CREATE LARGE TABLESPACE REG_DIM
 		PAGESIZE 8K
 		MANAGED BY AUTOMATIC STORAGE
 		USING STOGROUP SG_HOTEL
 		AUTORESIZE YES
 		BUFFERPOOL BP_DIM
 		EXTENTSIZE 100
		MAXSIZE 40G;

CREATE LARGE TABLESPACE IDX_DIM
 		PAGESIZE 8K
 		MANAGED BY AUTOMATIC STORAGE
 		USING STOGROUP SG_HOTEL
 		AUTORESIZE YES
 		BUFFERPOOL BP_DIM
 		EXTENTSIZE 100
 		MAXSIZE 40G;
 CREATE LARGE TABLESPACE LOB_DIM
 PAGESIZE 8K
 MANAGED BY AUTOMATIC STORAGE
 USING STOGROUP SG_HOTEL
 AUTORESIZE YES
 BUFFERPOOL BP_DIM
 EXTENTSIZE 100
 MAXSIZE 64G;
 CREATE BUFFERPOOL BP_FAK PAGESIZE 8K;
 CREATE LARGE TABLESPACE REG_FAK
 PAGESIZE 8K
 MANAGED BY AUTOMATIC STORAGE
 USING STOGROUP SG_HOTEL
 AUTORESIZE YES
 BUFFERPOOL BP_FAK
 EXTENTSIZE 100
 MAXSIZE 30G;
 CREATE LARGE TABLESPACE IDX_FAK
 PAGESIZE 8K
 MANAGED BY AUTOMATIC STORAGE
 USING STOGROUP SG_HOTEL
 AUTORESIZE YES
 BUFFERPOOL BP_DIM
 EXTENTSIZE 100
 MAXSIZE 30G;
 CREATE LARGE TABLESPACE LOB_FAK
 PAGESIZE 8K
 MANAGED BY AUTOMATIC STORAGE
 USING STOGROUP SG_HOTEL
 AUTORESIZE YES
 BUFFERPOOL BP_DIM
 EXTENTSIZE 100
 MAXSIZE 64G;


-- Create Hotel table
CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY NOT NULL,
    hotel VARCHAR(50) NOT NULL
)
 IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

-- Create Agent table
CREATE TABLE Agent (
    agent_id INT PRIMARY KEY NOT NULL,
    agent_name VARCHAR(100)
)
 IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

-- Create Company table
CREATE TABLE Company (
    company_id INT PRIMARY KEY NOT NULL,
    company_name VARCHAR(100)
)
 IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

-- Create Booking table
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY NOT NULL,
    hotel_id INT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month VARCHAR(20),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    country VARCHAR(50),
    market_segment VARCHAR(50),
    distribution_channel VARCHAR(50),
    agent_id INT,
    company_id INT,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
    FOREIGN KEY (agent_id) REFERENCES Agent(agent_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
)
 IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

-- Create GuestDetails table
CREATE TABLE GuestDetails (
    guest_details_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    booking_id INT,
    adults INT,
    children INT,
    babies INT,
    is_repeated_guest INT,
    total_of_special_requests INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
) IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

DROP TABLE GUESTDETAILS; 

-- Table for ReservationDetails
CREATE TABLE ReservationDetails (
    reservation_details_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    booking_id INT,
    is_canceled INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    meal VARCHAR(50),
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type VARCHAR(10),
    assigned_room_type VARCHAR(10),
    booking_changes INT,
    deposit_type VARCHAR(50),
    days_in_waiting_list INT,
    adr FLOAT,
    required_car_parking_spaces INT,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
)IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

DROP TABLE RESERVATIONDETAILS; 

-- Create Customer table

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    booking_id INT,
    customer_type VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
) IN REG_DIM
 INDEX IN IDX_DIM
 LONG IN LOB_DIM;

DROP TABLE CUSTOMER; 

CREATE TABLE hotel_bookings (
    hotel VARCHAR(255),
    is_canceled INT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month VARCHAR(50),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    adults INT,
    children INT,
    babies INT,
    meal VARCHAR(50),
    country VARCHAR(50),
    market_segment VARCHAR(50),
    distribution_channel VARCHAR(50),
    is_repeated_guest INT,
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type VARCHAR(10),
    assigned_room_type VARCHAR(10),
    booking_changes INT,
    deposit_type VARCHAR(50),
    agent VARCHAR(50),
    company VARCHAR(50),
    days_in_waiting_list INT,
    customer_type VARCHAR(50),
    adr FLOAT,
    required_car_parking_spaces INT,
    total_of_special_requests INT,
    reservation_status VARCHAR(50),
    reservation_status_date DATE
);