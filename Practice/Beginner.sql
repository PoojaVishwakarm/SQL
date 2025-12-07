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

-- Find the total score for each country
select
country,
SUM(score)
from customers
group by country

/* 
Find the total score and total 
number of customers for each country
*/
select 
country,
count(*),
SUM(score) as Total_Score
from customers
group by country

/*
Find the average score for each country
considering only customers with a score not equal to 0
and return only those countries with an average score greater than 430
*/
select
country,
AVG(score) as avg_total
from customers
where score !=0
group by country
having AVG(score)>430

--Return unique list of all countries
select distinct country 
from customers

--Retrieve only 3 customers
select top 3 * from customers

-- Retrieve the top 3 customers with the highest scores
select top 3 * from customers
 order by score desc

 -- Retrieve th elowest 2 customers based on the score
 select top 2 * from customers
 order by  score asc

 -- Get the two most recent orders
 select * from orders
 order by order_date desc

 /*
 ============================================================================
 ===============================================================================
 */

 select 123 as static_number

 --=========================  Data Definition Language  ==========================
 
 /*
 Create a new tanle called persons
 with columns: id person_name, birth_date and phone
 */
 drop table Persons

 CREATE TABLE Persons(
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);

--================= Alter ==============

-- Add a new column called email to the person table
alter table Persons
add email varchar(20) not null


-- Remove the columns phone from the persond table
alter table Persons
drop column phone 

--Delete the table persons from the database
delete from Persons

drop table Persons
select * from Persons

/*
==============================================================================
========================== Data Manipulation Language ========================
==============================================================================
                Insert  Update Delete
*/
insert into customers(id,first_name)
values
(10,'Andreas')

select * from customers

-- Insert data from 'customers' into 'persons'
insert into Persons(id,person_name,birth_date,phone)
select 
id,
first_name,
null,
'Unknown'
from customers

select * from Persons


--------------- Update-------------------------------

--Change the score of customers with ID 6 to 0
update customers
set score=0
where id=6

-- Change the score of customers with ID 10 to 0 and update the country to UK

update customers
set score=0 ,country='UK'
where id=10

-- Update all customers with a null score by setting thier score to 0
update customers
set score=0
where score is null

--Delete all customers with an ID greater than 5
delete from customers
where id >5


-- Delete all data from the persons table
 delete from customers

truncate table Persons
  
select * from customers

