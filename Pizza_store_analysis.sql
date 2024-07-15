CREATE DATABASE pizza;


create table orders 
(
	order_id int not null,
	order_date date not null,
	order_time time not null,
	primary key(order_id)
);



create table order_details
 (
	order_details_id int not null,
	order_id int not null,
	pizza_id text not null,
	quantity int not null,
	primary key(order_details_id)
);


-- Retrieve the total number of orders placed.

Select
count(order_id) 
as Total_Orders from orders;



-- Calculate the total revenue generated from pizza sales.

Select
round(sum(od.quantity*p.price),2) as Total_revenue
from  order_details od inner join pizzas p 
on   od.pizza_id=p.pizza_id;



-- Identify the highest-priced pizza.

Select
pt.name,pt.category,p.price
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
order by p.price desc
limit 1;



-- Identify the most common pizza size ordered.

Select p.size,count(od.quantity) as q
from order_details od inner join pizzas p
on od.pizza_id=p.pizza_id
group by p.size
order by q desc 
limit 1;


 
-- List the top 5 most ordered pizza types along with their quantities.

Select
pt.name , sum(od.quantity) as total_count
from pizza_types  pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by pt.name
order by total_count desc
limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

Select 
pt.category,sum(od.quantity) as quantity
from pizzas p join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
join order_details od
on p.pizza_id=od.pizza_id
group by pt.category 
order by quantity desc;



-- Join relevant tables to find the category-wise distribution of pizzas.

Select 
hour(order_time) as Distribution,count(order_id) as quantity
from orders o
group by Distribution;



-- Join relevant tables to find the category-wise distribution of pizzas.

Select
category,count(pizza_type_id) as Quantity
from pizza_types 
group by category;
    
    

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
pt.name,
sum(od.quantity * p.price) as revenue
from 
pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by pt.name
order by revenue desc
limit 3;



-- Calculate the percentage contribution of each pizza type to total revenue.

Select pt.category ,
(sum(p.price*od.quantity)/
(select 
    round(sum(p.price*od.quantity),3) 
	from order_details od join pizzas p 
	on p.pizza_id=od.pizza_id))*100
as Percentage
from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by pt.category
order by Percentage ;



