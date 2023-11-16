# Design Data Model for Uber
<img src='https://github.com/Kamaljit12/Data-Warehousing/blob/main/png/uber.jpg'>
### First let’s understand the important business metrics which we need to derive from the data model:

1. Average ride duration and distance per city.
2. Revenue generated per city.
3. Peak times for rides in different locations.
4. Popular routes and destinations.
5. Average rider rating per driver.
6. Average driver rating per rider.
7. Time taken by a driver from ride acceptance to customer pickup.
8. Rate of ride cancellations by riders and drivers.
9. Impact of weather on ride demand.
10. Rider loyalty metrics such as frequency of use, average spend, and length of customer relationship

## Design Data Model for Uber
- ### Now prepare dimension tables:

<img src='https://github.com/Kamaljit12/Data-Warehousing/blob/main/png/uber_data_model.jpg'>

# Design Data Model for Uber
#### RideStatus table should be Dimension table or Fact?
- The RideStatus table contains ride_id, and this could introduce some potential confusion or challenges. 
Generally, dimension tables in a data warehouse schema shouldn't contain foreign keys from fact tables (like 
ride_id from the Rides table) because this could result in them having a one-to-one relationship with the fact table, 
and could lead to the dimension table effectively becoming another fact table.

- The RideStatus table, in the proposed schema is tracking the different statuses that a ride could go through in its 
lifecycle. In this case, RideStatus would be better designed as a slowly changing dimension table or as a 
transaction fact table, depending on the business requirements.

<b>If you want to track only the current status of each ride, then RideStatus could be a slowly changing 
dimension with ride_id as a foreign key and status as an attribute.</b>

- Alternatively, if you want to track all status changes for every ride, then RideStatus could be designed as a 
transaction fact table that captures each status update as a new row, with ride_id, status, and timestamp as 
attributes. In this case, ride_id in RideStatus wouldn't be a foreign key from Rides table, but rather a degenerate 
dimension.
- Ultimately, the decision will depend on your specific use case and requirements. In general, it's important to ensure 
that dimension tables in a star schema contain attributes that can be used to slice and dice the measures stored in 
the fact table.

### Now prepare fact table:

      # Rides
      ride_id (PK)
      driver_id (FK)
      rider_id (FK)
      start_location_id (FK)
      end_location_id (FK)
      ride_date_time (FK)
      ride_duration
      ride_distance
      fare
      rating_by_driver
      rating_by_rider
# Design Data Model for Uber

<img src = 'https://github.com/Kamaljit12/Data-Warehousing/blob/main/png/uber_model_1.jpg'>

# SQL Queries to get business insights:
1. ### Average ride duration and distance per city
   
        SELECT c.city_name, AVG(r.ride_duration), AVG(r.ride_distance)
        FROM Rides r
        JOIN Locations l ON r.start_location_id = l.location_id
        JOIN Cities c ON l.city_id = c.city_id
        GROUP BY c.city_name;
   
2. ### Revenue generated per city
   
        SELECT c.city_name, SUM(r.fare)
        FROM Rides r
        JOIN Locations l ON r.start_location_id = l.location_id
        JOIN Cities c ON l.city_id = c.city_id
        WHERE r.status = 'completed'
        GROUP BY c.city_name;
   
3. ### Peak times for rides in different locations
   
        SELECT l.location_name, d.hour, COUNT(*)
        FROM Rides r
        JOIN Locations l ON r.start_location_id = l.location_id
        JOIN Dates d ON r.ride_date_time = d.date_time
        GROUP BY l.location_name, d.hour
        ORDER BY COUNT(*) DESC;
        
4. ### Popular routes and destinations
   
        SELECT l1.location_name AS start_location, l2.location_name AS end_location, COUNT(*) AS number_of_rides
        FROM Rides r
        JOIN Locations l1 ON r.start_location_id = l1.location_id
        JOIN Locations l2 ON r.end_location_id = l2.location_id
        GROUP BY l1.location_name, l2.location_name
        ORDER BY number_of_rides DESC;
   
5. ### Average rider rating per driver
   
        SELECT d.driver_name, AVG(r.rating_by_driver)
        FROM Rides r
        JOIN Drivers d ON r.driver_id = d.driver_id
        GROUP BY d.driver_name;
   
6. ### Average driver rating per rider
    
        SELECT ri.rider_name, AVG(r.rating_by_rider)
        FROM Rides r
        JOIN Riders ri ON r.rider_id = ri.rider_id
        GROUP BY ri.rider_name;

7. ### Time taken by a driver from ride acceptance to customer pickup
     
        SELECT d.driver_id, d.driver_name, r.ride_id, 
        TIMEDIFF(pickup_status.time, acceptance_status.time) AS time_to_pickup
        FROM RideStatus acceptance_status 
        JOIN RideStatus pickup_status ON acceptance_status.ride_id = pickup_status.ride_id
        JOIN Rides r ON r.ride_id = acceptance_status.ride_id
        JOIN Drivers d ON r.driver_id = d.driver_id
        WHERE acceptance_status.status = 'accepted' 
        AND pickup_status.status = 'started';
    
8. ### Rate of ride cancellations by riders and drivers
    
        SELECT 
         (SELECT COUNT(DISTINCT ride_id) FROM RideStatus WHERE status = 'cancelled_by_driver') * 1.0 / 
         (SELECT COUNT(DISTINCT ride_id) FROM Rides) as driver_cancellation_rate,
         (SELECT COUNT(DISTINCT ride_id) FROM RideStatus WHERE status = 'cancelled_by_rider') * 1.0 / 
         (SELECT COUNT(DISTINCT ride_id) FROM Rides) as rider_cancellation_rate;

9. ### Impact of weather on ride demand
    
        SELECT w.weather_condition, COUNT(*) AS number_of_rides
        FROM Rides r
        JOIN Locations l ON r.start_location_id = l.location_id
        JOIN Weather w ON l.city_id = w.city_id
        AND DATE_FORMAT(r.ride_date_time, '%Y-%m-%d %H:00:00') = w.date_time
        GROUP BY w.weather_condition;

10. ### Rider loyalty metrics
     
        SELECT ri.rider_name, COUNT(*), AVG(r.fare), DATEDIFF(MAX(r.ride_date_time), ri.signup_date) as days_since_signup
        FROM Rides r
        JOIN Riders ri ON r.rider_id = ri.rider_id
        GROUP BY ri.rider_name;

