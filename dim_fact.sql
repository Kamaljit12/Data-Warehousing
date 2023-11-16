create database sales;
use sales;


-- Create the time dimension table
CREATE TABLE time (
  time_id INT PRIMARY KEY,
  order_date DATE,
  month_name VARCHAR(10),
  quarter_name VARCHAR(10),
  year INT
);
INSERT INTO time (time_id, order_date, month_name, quarter_name, year)
VALUES (1, '2023-01-01', 'January', 'Q1', 2023),
       (2, '2023-01-02', 'January', 'Q1', 2023),
       (3, '2023-01-03', 'January', 'Q1', 2023),
       (4, '2023-01-04', 'January', 'Q1', 2023),
       (5, '2023-01-05', 'January', 'Q1', 2023);



-- Create the geography dimension table
CREATE TABLE geography (
  geography_id INT PRIMARY KEY,
  state_name VARCHAR(20),
  region_name VARCHAR(20)
);

INSERT INTO geography (geography_id, state_name, region_name)
VALUES (1, 'Maharashtra', 'West'),
       (2, 'Karnataka', 'South'),
       (3, 'Delhi', 'North'),
       (4, 'West Bengal', 'East'),
       (5, 'Tamil Nadu', 'South');

-- Create the product dimension table
CREATE TABLE product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(30),
  product_line VARCHAR(20),
  vendor_name VARCHAR(20)
);

INSERT INTO product (product_id, product_name, product_line, vendor_name)
VALUES (1, 'Laptop', 'Electronics', 'Dell'),
       (2, 'Smartphone', 'Electronics', 'Samsung'),
       (3, 'Book', 'Books', 'Penguin'),
       (4, 'Shirt', 'Clothing', "Levi's"),
       (5, 'Shoes', 'Clothing', 'Nike');

-- Create the customer dimension table
CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(30),
  company_name VARCHAR(20)
);
INSERT INTO customer (customer_id, customer_name, company_name)
VALUES (1, 'Alice', 'ABC Inc.'),
       (2, 'Bob', 'XYZ Ltd.'),
       (3, 'Charlie', 'PQR Pvt.'),
       (4, 'David', 'LMN Co.'),
       (5, 'Eve', 'RST Corp.');


-- Create the sales fact table
CREATE TABLE sales (
  sales_id INT PRIMARY KEY,
  time_id INT REFERENCES time(time_id),
  geography_id INT REFERENCES geography(geography_id),
  product_id INT REFERENCES product(product_id),
  customer_id INT REFERENCES customer(customer_id),
  units_sold INT,
  revenue DECIMAL(10,2),
  cost DECIMAL(10,2),
  profit DECIMAL(10,2)
);
INSERT INTO sales (sales_id, time_id, geography_id, product_id, customer_id, units_sold, revenue, cost, profit)
VALUES (1, 1, 1, 1, 1, 10, 100000, 80000, 20000),
       (2, 2, 2, 2, 2, 20, 80000, 60000, 20000),
       (3, 3, 3, 3, 3, 30, 60000, 40000, 20000),
       (4, 4, 4, 4, 4, 40, 40000, 20000, 20000),
       (5, 5, 5, 5, 5, 50, 20000, 10000, 10000);

