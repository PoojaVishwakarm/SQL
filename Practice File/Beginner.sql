use MyDatabase

-- Retrieve all customers Data
select * from customers

-- Retrieve all Order Data
select * from orders

-- Retrieve all Order Data
select * from persons

--Retrieve eac customers name country and score
select 
	first_name,
	country,
	score
from customers

--Retrieve customers with a score not equal to 0
select * from customers
where score !=0

-- Retrieve customers from germany
select * from customers
where country='Germany'

/* 
Retrieve all customers and
 sort the results  by the highest score first
*/

select * from customers
order by score desc

/* 
Retrieve all customers and
 sort the results  by the lowest score first
*/

select * from customers
order by score asc

/*
Retrieve all customers and sort the results by the country
and then by the highest score
*/
select *
from customers
order by country asc, score desc