create database pizzahut; 
create table orders
(order_id int not null, 
order_date date not null,
order_time time not null, 
primary key (order_id));   

create table order_details
(order_details_id int not null,
order_id int not null, 
pizza_id text not null,
quantity int not null, 
primary key (order_details_id)); 

use pizzahut; 
show tables; 
select * from pizzas; 
select * from pizza_types;
select * from orders; 
select * from order_details; 

-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id)
FROM
    orders; 

-- Calculate the total revenue generated from pizza sales.
select * from pizzas; 
select * from order_details; 

select p.pizza_id, (od.quantity*p.price) as tot_sales  
from pizzas p inner join order_details od 
on od.pizza_id = p.pizza_id ;  

select sum(od.quantity*p.price) as tot_revenue  
from pizzas p inner join order_details od 
on od.pizza_id = p.pizza_id 
;   

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS tot_revenue
FROM
    pizzas p
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id
; 



select sum(price) as tot_revenue from pizzas; 

-- Identify the highest-priced pizza.
select * from pizzas; 
select * from pizza_types; 

SELECT 
    pt.name, p.price
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY 2 DESC
LIMIT 1; 

-- Identify the most common pizza size ordered.
select * from pizzas; 
select * from order_details;  

SELECT 
    size, COUNT(quantity)
FROM
    pizzas p
        INNER JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
; 

-- List the top 5 most ordered pizza types along with their quantities.
select * from pizzas; 
select * from pizza_types;
select * from order_details;  

SELECT 
    pt.name, SUM(quantity)
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
; 

-- Join the necessary tables to find the total quantity of each pizza category ordered. 
select * from pizzas; 
select * from pizza_types;
select * from order_details; 

SELECT 
    pt.category, SUM(od.quantity) AS tot_quant
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC; 
    
-- Determine the distribution of orders by hour of the day. 
SELECT 
    HOUR(order_time)as hour, COUNT(order_id)as no_of_pizzas
FROM
    orders
GROUP BY 1
;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, count(name) from 
    pizza_types 
GROUP BY 1
; 

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select order_date, sum(quantity) from orders o inner join order_details od
on o.order_id = od.order_id
group by 1 
; 

SELECT 
    AVG(no_pizza_perday)
FROM
    (SELECT 
        order_date, SUM(quantity) AS no_pizza_perday
    FROM
        orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY 1) per_day_no; 

-- Determine the top 3 most ordered pizza types based on revenue. 
SELECT 
    pt.name, SUM(quantity * p.price) AS tot_rev
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    (SUM(quantity * p.price) / (SELECT 
            SUM(od.quantity * p.price) AS tot_sales
        FROM
            pizzas p
                INNER JOIN
            order_details od ON od.pizza_id = p.pizza_id)) * 100 AS tot_rev
FROM
    pizzas p
        INNER JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 1
ORDER BY 2 DESC
;

-- Analyze the cumulative revenue generated over time.  

select order_date,  ROUND(SUM(od.quantity * p.price), 2) AS tot_revenue
FROM
    pizzas p
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id inner join orders o 
on o.order_id = od.order_id 
group by 1
; 

-- ans
select order_date, sum(tot_revenue) over(order by order_date) as cumilative_rev 
from 
(select order_date,  ROUND(SUM(od.quantity * p.price), 2) AS tot_revenue
FROM
    pizzas p
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id inner join orders o 
on o.order_id = od.order_id 
group by 1) sales 
;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select pt.category, pt.name, ROUND(SUM(od.quantity * p.price), 2) AS tot_revenue
FROM
    pizzas p
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id inner join pizza_types pt 
on pt.pizza_type_id = p.pizza_type_id 
group by 1, 2
; 

select category, name, tot_revenue, ranks from
(select category, name, tot_revenue, 
rank() over(partition by category order by tot_revenue) as ranks
from
(select pt.category, pt.name, ROUND(SUM(od.quantity * p.price), 2) AS tot_revenue
FROM
    pizzas p
        INNER JOIN
    order_details od ON od.pizza_id = p.pizza_id inner join pizza_types pt 
on pt.pizza_type_id = p.pizza_type_id 
group by 1, 2) categ_rev ) rev_rank 
where ranks<= 3;



select * from pizzas; 
select * from pizza_types; 
select * from orders; 
select * from order_details; 