# Design Data Model for Uber

    create database uber;
    
    use uber;


## driver table

    create table if not exists Drivers
      (
        driver_id int primary key,
        driver_name varchar(30),
        driver_phone_number varchar(20),
        driver_email varchar(50),
        signup_date datetime,
        vehical_type varchar(50),
        driver_city_id varchar(20) references riders(rider_city_id)
        );

 ![image](https://github.com/Kamaljit12/Data-Warehousing/assets/89628021/42fdc59a-2bd0-4240-9c0e-cff42602684c)


    
## date table

    create table if not exists 	dates
    	(
        date_time datetime,
        day varchar(10),
        month varchar(10),
        year int,
        weekday varchar(10)
        );


   
## riders table

     create table if not exists riders
    	(
        rider_id int primary key,
        rider_name varchar(25),
        rider_phone_number varchar(20),
        rider_email varchar(50),
        signup_date datetime,
        loyality_status varchar(100),
        rider_city_id int references drivers(driver_city_id)
        );
   

## rider status table

    create table if not exists riderStatus
    	(
        id int primary key,
        ride_id int,
        status varchar(30),
        status_time varchar(20)
        );


## location table

    create table if not exists location	
    	(
        location_id int primary key,
        city_id int references city(city_id),
        location_name varchar(50),
        latitude varchar(30),
        longitude varchar(50)
        );

## weather table


    create table if not exists weather
    	(
        weather_id int primary key,
        city_id int references city(city_id),
        date_time datetime references dates(date_time),
        weather_condition enum("rain", "sunny", "snowy"),
        temperature varchar(5)
        );
    
## cities table
    
    create table if not exists cities
    	(
        city_id int primary key,
        city_name varchar(20),
        state varchar(30),
        country varchar(30)
        );
    
    
## Fact table 

    create table if not exists rides
    	(
        ride_id int,
        driver_id int references drivers(driver_id),
        rider_id int references riders(rider_id),
        start_location_id varchar(50) references location(location_id),
        end_location_id varchar(50) references location (location_id),
        ride_date_time datetime references dates(date_time),
        ride_duration time,
        ride_distance int,
        fare float,
        rating_by_driver varchar(10),
        rating_by_rider varchar(10)
        );
![image](https://github.com/Kamaljit12/Data-Warehousing/assets/89628021/ef27c813-7b62-43ba-b6bc-79255b359fae)

## data modelling for uber
