CREATE DATABASE Restaurant;

USE Restaurant;

CREATE TABLE ORDERS(
order_id INTEGER NOT NULL,
order_customer_id INTEGER NOT NULL,
order_employee_id INTEGER NOT NULL,
order_date DATE NOT NULL,
CONSTRAINT PK_order_id PRIMARY KEY(order_id)
);

CREATE TABLE CUSTOMER(
customer_id INTEGER NOT NULL, 
first_name VARCHAR(55) NOT NULL,
last_name VARCHAR(55) NOT NULL,
phone_number VARCHAR(55) NOT NULL,
CONSTRAINT PK_customer PRIMARY KEY(customer_id)
);

CREATE TABLE EMPLOYEE(
employee_id INTEGER NOT NULL,
employee_location_id INTEGER NOT NULL,
first_name VARCHAR(55) NOT NULL,
last_name VARCHAR(55) NOT NULL,
age INTEGER NOT NULL,
phone_number VARCHAR(55) NOT NULL,
CONSTRAINT PK_employee PRIMARY KEY(employee_id)
);  
SELECT * FROM EMPLOYEE;


--  BEFORE INSERT TRIGGER
DELIMITER //
CREATE TRIGGER age_verify
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
IF new.age < 0 then set new.age = 0;
END IF;//


CREATE TABLE LOCATION(
location_id INTEGER NOT NULL,
employee_location_id INTEGER NOT NULL,
city VARCHAR(55),
street VARCHAR(55) NOT NULL,
post_code VARCHAR(55) NOT NULL,
building_number VARCHAR(55) NOT NULL,
country VARCHAR(55),
CONSTRAINT PK_location PRIMARY KEY(location_id)
);



CREATE TABLE MENU1(
food_id INTEGER NOT NULL,
traditional_food VARCHAR(55) NOT NULL,
price DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_food PRIMARY KEY(food_id)
);

CREATE TABLE MENU2(
food_id INTEGER NOT NULL,
dessert VARCHAR(55) NOT NULL,
price DECIMAL(6,2) NOT NULL,
CONSTRAINT PK_food_id PRIMARY KEY(food_id)
);


INSERT INTO ORDERS
(order_id, order_customer_id, order_employee_id, order_date)
VALUES
(120, 1, 01, '2020-08-20'),
(150, 2, 02,  '2021-07-01'),
(190, 3, 03,  '2021-11-09'),
(200, 4, 04, '2022-05-21');


SELECT * FROM ORDERS;

INSERT INTO CUSTOMER
(customer_id, first_name, last_name, phone_number)
VALUES
(1, 'Oana','Panaite', '555-9900'),
(2, 'Savannah','Richardson', '555-4411'),
(3, 'Elena','Kirsch', '555-6767'),
(4, 'Lucian','Corbu', '555-0021'),
(5, 'Emma', 'Stone', '555-8876');

SELECT * FROM CUSTOMER;


INSERT INTO EMPLOYEE
(employee_id, employee_location_id, first_name, last_name, age, phone_number)
VALUES
(01, 1, 'Alexandra','Vladu', 22 ,  '555-3344'),
(02, 2, 'Noah','Kirsch', 25 , '555-3266'),
(03, 2, 'Katherine','Pierce', -2, '555-3199'),
(04, 1, 'Zoe', 'Bloom', 21, '555-2610');

SELECT * FROM EMPLOYEE;


INSERT INTO LOCATION
(location_id, employee_location_id, city, street, post_code, building_number, country)
VALUES
(001, 1, 'London', 'Main street', 'E1 7AD', '21', 'United Kingdom'),
(002, 2, 'Bucharest', 'Calea Victoriei', '345 RO', '5', 'Romania');

SELECT * FROM LOCATION;



INSERT INTO MENU1 
(food_id, traditional_food, price)
VALUES
(0001, 'Cabbage rolls', 9.99),
(0002, 'Roasted eggplant salad',  12.70),
(0003, 'Radauti soup', 6.99),
(0004, 'Lamb drob',  15.50),
(0005, 'Russian salad', 5.99),
(0006, 'Moldavian stew', 10.99);

SELECT * FROM MENU1;

INSERT INTO MENU2
(food_id, dessert, price)
VALUES
(0001, 'Diplomat cake',  13.60),
(0002, 'Sweet bread', 12.70),
(0003, 'Apple pie', 9.99),
(0004, 'Romanian chocolate cake',  14.50),
(0005, 'Papanasi',  4.99),
(0006, 'Plum dumplings', 3.99);

SELECT * FROM MENU2;


-- EXTRA! CREATE A VIEW TO SHOW ALL PRODUCTS THAT ARE ABOVE THE AVERAGE PRICE IN MENU2
CREATE VIEW above_average_price AS
SELECT dessert, price
FROM MENU2
WHERE price > (SELECT AVG(Price) FROM  MENU2);

SELECT * FROM above_average_price;

-- QUERY TO FIND THE DESSERTS THAT COST OVER 10 pounds
SELECT DISTINCT dessert, Max(price)
FROM above_average_price 
WHERE Price > 10
GROUP BY dessert;

-- CROSS JOIN
SELECT m1.*, m2.*
FROM MENU1 m1
CROSS JOIN MENU2 m2;


-- FOREIGN KEY
ALTER TABLE ORDERS
ADD CONSTRAINT FK_customer_id
FOREIGN KEY (order_customer_id)
REFERENCES CUSTOMER(customer_id); 

SELECT * FROM MENU1;

-- STORED PROCEDURE
CALL show_Traditional_food()


-- MORE FOREIGN KEYS
ALTER TABLE ORDERS
ADD CONSTRAINT FK_employee_id
FOREIGN KEY (order_employee_id)
REFERENCES EMPLOYEE(employee_id);


ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_employee
FOREIGN KEY (employee_location_id)
REFERENCES LOCATION (location_id);


ALTER TABLE MENU1
ADD CONSTRAINT FK_food
FOREIGN KEY (food_id)
REFERENCES MENU2 (food_id);


-- QUERY WITH A SUBQUERY
SELECT food_id, dessert
FROM MENU2
WHERE price < (SELECT AVG(price) 
               FROM MENU2);

-- STORED FUNCTION
CREATE FUNCTION check_age(first_name VARCHAR(50), age INT)
RETURNS VARCHAR(100) DETERMINISTIC
RETURN CONCAT_WS ( ' ', first_name, 'is', age, 'years old');


SELECT check_age(first_name, age)
FROM EMPLOYEE;


