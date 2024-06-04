-- Insert data into Hotel table
INSERT INTO Hotel (hotel_id, hotel) VALUES
(1, 'Resort Hotel'),
(2, 'City Hotel');

-- Insert data into Agent table
INSERT INTO Agent (agent_id, agent_name)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY agent) AS agent_id,
    agent
FROM hotel_bookings;

 
-- Insert data into Agent table
INSERT INTO Agent (agent_id, agent_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY AGENT_NAME) AS agent_id,
    agent_name
FROM (
    SELECT DISTINCT 
        agent AS agent_name
    FROM hotel_bookings
) AS unique_agents;
  

-- Insert data into Company table
INSERT INTO Company (company_id, company_name)
SELECT DISTINCT 
    ROW_NUMBER() OVER (ORDER BY company) AS company_id,
    company
FROM hotel_bookings
WHERE company IS NOT NULL;

-- Insert data into Company table
INSERT INTO Company (company_id, company_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY company_name) AS company_id,
    company_name
FROM (
    SELECT DISTINCT 
        company AS company_name
    FROM hotel_bookings
    WHERE company IS NOT NULL
) AS unique_companies;
 
-- Insert data into Booking table
INSERT INTO Booking (
    booking_id, hotel_id, lead_time, arrival_date_year, arrival_date_month, 
    arrival_date_week_number, arrival_date_day_of_month, country, market_segment, 
    distribution_channel, agent_id, company_id
)
SELECT 
    ROW_NUMBER() OVER () AS booking_id,
    CASE 
        WHEN hb.hotel = 'Resort Hotel' THEN 1 
        WHEN hb.hotel = 'City Hotel' THEN 2 
    END AS hotel_id,
    hb.lead_time, hb.arrival_date_year, hb.arrival_date_month, 
    hb.arrival_date_week_number, hb.arrival_date_day_of_month, hb.country, hb.market_segment, 
    hb.distribution_channel, 
    a.agent_id,
    c.company_id
FROM hotel_bookings hb
LEFT JOIN Agent a ON hb.agent = a.agent_name
LEFT JOIN Company c ON hb.company = c.company_name
FETCH FIRST 1000 ROWS ONLY;

INSERT INTO Booking (
    booking_id, hotel_id, lead_time, arrival_date_year, arrival_date_month, 
    arrival_date_week_number, arrival_date_day_of_month, country, market_segment, 
    distribution_channel, agent_id, company_id
)
SELECT 
    ROW_NUMBER() OVER () AS booking_id,
    CASE 
        WHEN hb.hotel = 'Resort Hotel' THEN 1 
        WHEN hb.hotel = 'City Hotel' THEN 2 
    END AS hotel_id,
    hb.lead_time, hb.arrival_date_year, hb.arrival_date_month, 
    hb.arrival_date_week_number, hb.arrival_date_day_of_month, hb.country, hb.market_segment, 
    hb.distribution_channel, 
    a.agent_id,
    c.company_id
FROM (
    SELECT *, ROW_NUMBER() OVER () AS row_num
    FROM hotel_bookings
) AS hb
LEFT JOIN Agent a ON hb.agent = a.agent_name
LEFT JOIN Company c ON hb.company = c.company_name
WHERE hb.row_num BETWEEN 1 AND 119390; -- Masukkan angka batch secara langsung di sini

-- Insert data into ReservationDetails table
INSERT INTO ReservationDetails (
    reservation_details_id, booking_id, is_canceled, stays_in_weekend_nights, 
    stays_in_week_nights, meal, previous_cancellations, 
    previous_bookings_not_canceled, reserved_room_type, 
    assigned_room_type, booking_changes, deposit_type, 
    days_in_waiting_list, adr, required_car_parking_spaces
)
SELECT 
    ROW_NUMBER() OVER () AS reservation_details_id,
    b.booking_id,
    is_canceled, stays_in_weekend_nights, 
    stays_in_week_nights, meal, previous_cancellations, 
    previous_bookings_not_canceled, reserved_room_type, 
    assigned_room_type, booking_changes, deposit_type, 
    days_in_waiting_list, adr, required_car_parking_spaces
FROM hotel_bookings hb
JOIN Booking b ON hb.lead_time = b.lead_time AND 
    CASE 
        WHEN hb.hotel = 'Resort Hotel' THEN 1 
        WHEN hb.hotel = 'City Hotel' THEN 2 
    END = b.hotel_id;

-- Insert into ReservationDetails
INSERT INTO ReservationDetails (booking_id, is_canceled, stays_in_weekend_nights, stays_in_week_nights, meal, previous_cancellations, previous_bookings_not_canceled, reserved_room_type, assigned_room_type, booking_changes, deposit_type, days_in_waiting_list, adr, required_car_parking_spaces)
SELECT 
    b.booking_id,
    hb.is_canceled,
    hb.stays_in_weekend_nights,
    hb.stays_in_week_nights,
    hb.meal,
    hb.previous_cancellations,
    hb.previous_bookings_not_canceled,
    hb.reserved_room_type,
    hb.assigned_room_type,
    hb.booking_changes,
    hb.deposit_type,
    hb.days_in_waiting_list,
    hb.adr,
    hb.required_car_parking_spaces
FROM hotel_bookings hb
JOIN Booking b ON 
    b.hotel_id = (SELECT hotel_id FROM Hotel WHERE hotel = hb.hotel) AND
    b.lead_time = hb.lead_time AND
    b.arrival_date_year = hb.arrival_date_year AND
    b.arrival_date_month = hb.arrival_date_month AND
    b.arrival_date_week_number = hb.arrival_date_week_number AND
    b.arrival_date_day_of_month = hb.arrival_date_day_of_month;

-- Insert into Customer with a limit of 10,000 records
INSERT INTO Customer (booking_id, customer_type)
SELECT 
    b.booking_id,
    hb.customer_type
FROM hotel_bookings hb
JOIN Booking b ON 
    b.hotel_id = (SELECT hotel_id FROM Hotel WHERE hotel = hb.hotel) AND
    b.lead_time = hb.lead_time AND
    b.arrival_date_year = hb.arrival_date_year AND
    b.arrival_date_month = hb.arrival_date_month AND
    b.arrival_date_week_number = hb.arrival_date_week_number AND
    b.arrival_date_day_of_month = hb.arrival_date_day_of_month;
    
-- Insert into GuestDetails
INSERT INTO GuestDetails (booking_id, adults, children, babies, is_repeated_guest, total_of_special_requests)
SELECT 
    b.booking_id,
    hb.adults,
    hb.children,
    hb.babies,
    hb.is_repeated_guest,
    hb.total_of_special_requests
FROM hotel_bookings hb
JOIN Booking b ON 
    b.hotel_id = (SELECT hotel_id FROM Hotel WHERE hotel = hb.hotel) AND
    b.lead_time = hb.lead_time AND
    b.arrival_date_year = hb.arrival_date_year AND
    b.arrival_date_month = hb.arrival_date_month AND
    b.arrival_date_week_number = hb.arrival_date_week_number AND
    b.arrival_date_day_of_month = hb.arrival_date_day_of_month;