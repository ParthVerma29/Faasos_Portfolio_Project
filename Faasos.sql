CREATE DATABASE faasos;
USE faasos;

CREATE TABLE driver (
    driver_id INT,
    reg_date DATE
); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');


CREATE TABLE ingredients (
    ingredients_id INTEGER,
    ingredients_name VARCHAR(60)
); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');


CREATE TABLE rolls (
    roll_id INTEGER,
    roll_name VARCHAR(30)
); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');


CREATE TABLE rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24)
); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');


CREATE TABLE driver_order (
    order_id INTEGER,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-03 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40','NaN'),
(5,3,'2021-01-08 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2020-01-08 21:30:45','25km','25mins',null),
(8,2,'2020-01-10 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2020-01-11 18:50:20','10km','10minutes',null);


CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','2021-01-01 18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1,5','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2,6','1,4','2021-01-11 18:34:49');

SELECT 
    *
FROM
    customer_orders;
SELECT 
    *
FROM
    driver_order;
SELECT 
    *
FROM
    ingredients;
SELECT 
    *
FROM
    driver;
SELECT 
    *
FROM
    rolls;
SELECT 
    *
FROM
    rolls_recipes;
/* 
drop table customer_orders;
drop table driver;
drop table driver_order;
drop table ingredients;
drop table rolls_recipes;
drop table rolls;
*/


/*
Question 1. How many roles were ordered ?
*/

SELECT 
    COUNT(roll_id)
FROM
    customer_orders;


/* 
Question 2. How many unique customer orders were made?
*/

SELECT 
    COUNT(DISTINCT customer_id)
FROM
    customer_orders;


/* 
Question 3. How many orders were delivered by the driver?
*/


SELECT 
    driver_id, COUNT(DISTINCT order_id)
FROM
    driver_order
WHERE
    cancellation NOT IN ('Cancellation' , 'Customer Cancellation')
GROUP BY driver_id;


/* 
Question 4. How many each type of roll was delivered?
*/

SELECT 
    roll_id, COUNT(roll_id)
FROM
    customer_orders
WHERE
    order_id IN (SELECT 
            order_id
        FROM
            (SELECT 
                *,
                    CASE
                        WHEN cancellation IN ('Cancellation' , 'Customer Cancellation') THEN 'c'
                        ELSE 'nc'
                    END AS order_cancel_details
            FROM
                driver_order) a
        WHERE
            order_cancel_details = 'nc')
GROUP BY roll_id;


/* 
Question 5. How many Veg and Non Veg Rolls were ordered by each customer?
*/

SELECT 
    a.*, b.roll_name
FROM
    (SELECT 
        customer_id, roll_id, COUNT(roll_id) cnt
    FROM
        customer_orders
    GROUP BY customer_id , roll_id) a
        INNER JOIN
    rolls b ON a.roll_id = b.roll_id;

/*
What was the maximum number of rolls delivered in a single order?
*/ 
select * from
(
select *,rank() over(order by cnt desc) rnk from
(
select order_id,count(roll_id) cnt
from (
select * from customer orders where order_id in (
select order_id from
(select *, case when cancellation in ("Cancellation", "Customer Cancellation") then 'c' else 'nc' end as order_cancel_details from driver_order)a
 where order_cancel_details='nc'))b
group by order_id
)c)d where rnk=1;




