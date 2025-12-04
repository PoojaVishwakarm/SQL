/*
=============================================================
=======================  Filterting Data=====================
=============================================================
1. Comparison Operators
   = 
   <> 
   =! 
   > 
   >= 
   < 
   <=
2. Logical Oprators
    1.AND
    2.OR
    3.NOT
3. Range Operator 
    1. Between
4.Membership Operator
    1. IN
    2. NOT IN
5. Seach Operator
    1.LIKE
*/


-- Retrieve all customers from Germany
select * from customers
where country='Germany'


--Rtrieve all customers who aer not from Germany
select * from customers
where country != 'Germany'

--Retrievev all customers with a score greater than 500
select * from customers
where score > 500

-- Rtrivev all customers with a score of 500 or more
select * from customers
where score >=500

--Retrieve all customers with a score less than 500
select * from customers 
where score <500

/*
===============================================================
===============================================================
                        Logical Operators
*/

/*
Retrieve all customers who are from usa and 
have a scoe greater than 500.
*/
 select * from customers
 where country='USA' and score> 500

 /*
Retrieve all customers who are either usa and 
have a scoe greater than 500.
*/
select * from customers
where country='USA' or score>500

-- Retrieve all customers with a score not less than 500
select * from customers
where score >= 500

/*
===============================================================
===============================================================
                        Range Operators
*/

/*
Retrieve all customers whose score fall 
in the range between 100 and 500
*/
select * from customers
where score between 100 and 500


/*
===============================================================
===============================================================
                        Membership Operators
*/

-- Retrieve all customers either egrmany or usa
select * from customers
where country in ('Germany','USA')



/*
===============================================================
===============================================================
                        Search Operators
*/

--Find the customers whose first name start with 'M'
select * from customers
where  first_name like 'm%'

-- Find all customers whose  first name ends with 'n'
select * from customers
where  first_name like '%n'

--Find the customers whose first name conatins 'r'
select * from customers
where first_name like '%r%'

-- Find the customers whose first name has 'r'
-- in the third position

select * from customers
where first_name like '__r%'


/*
=============================================================
=======================  Combining Data =====================
=============================================================
 1.Joins --- joined columns
   1.Basic  Joins
     a.inner join
       Return only matching rows from both tables
     b.left join
        Return alll rows from left and only matching from right
     c.right join
        Return all rows from right and only matching from left
     d.full join

   2. Advanced Joins
      a. left anti join
         Return row from left that has no match in right
      b. right anti join
      c. full anti join
         Return only rows that dont match in either tables
      d. cross join
    how to choose the right join
    how to join multiple tables

     ============================ Use Case =====================
     1. Recombine Data
     2.Data Enrichment  " Getting Extra Data"
     3.Check for Existence  "Filtering"

==================================================================================
*/

/*
Get all customers along with thier orders
but only for customers who have placed an orders
*/
select * from customers as c
inner join orders  as o
on c.id=o.customer_id

--Gwt all customers along with thier orders including those without orders
select * from   customers as c
left join  orders as o
on o.customer_id=c.id

-- Get all customers along with their orders
--including oredrs without matching customers

select * from customers as c
right join orders as o
on o.customer_id=c.id




--===========================Advanced Join=================
--==================================================================
 
 --Get all customers who havnt place any order
 select * from customers as c
 left join orders as o
 on c.id=o.customer_id
 where o.customer_id is null


 --Get all orders without matcing customers
 select * from customers as c
 right join orders as o
 on o.customer_id=c.id
 where c.id is null

 -- Find customers without orders and ordes without customers
 select * from customers as c
 full join orders as o
 on o.customer_id=c.id
 where c.id is null or o.customer_id is null
   
 -- Get all customers along with their orders
 -- but only for customers who have placed an order

 select * from customers as c
 left join orders as o
 on c.id=o.customer_id
 where o.customer_id  is not null


 -- Generate all possible combinations of customers and orders
  select * from customers
  cross join orders
 /*
 ======================================================================================
 ======================================================================================
 ======================================================================================

 2.Set Operators-- joined rows
   1. Union all
      - Returns all rows from both queries, including duplicates
   2. Union
      - Returns all diastrict rows from both queries
      - Remove dupicate rows from the result
   3. Except
      - Returns all distinct rows from the first query
        that are not found in the second query
      - Is is the only one where the order of queries affects the final results
      - Except operator can be used to campare tables
         to detect deiscrepancies between databases.
 4. Intersect
       - Returns only the rows that are common in the both queries.

   RULE
   1. Set Operator can be used almost in all clauses
      where | join | group by | having
   2. Order by is allowed only once at the end of query
   3. The number of coluns in each query must be the same
   4. Data types of columsn in each query must be compatible
   5. The order of the columns in each query must be the same
   6. The columns name in the the results set are determined by
      the column names specified in the first query.
   7. Even if all rule are met and SQL shows no erros
      the results may by incorrect
      Incorrect column selection leads to inaccurate results.
   
 */
 
 select
 FirstName,
 LastName
 from Sales.Customers
 union 
 select 
 FirstName,
 LastName
 from Sales.Employees

 --Combine the data from employees and customers into one table
 select 
 CustomerID,
 FirstName,
 LastName
 from Sales.Customers

 union

 select 
 EmployeeID,
 FirstName,
 LastName
 from Sales.Employees


 --Combine the data from employees ans customers into one table
  select 
 CustomerID,
 FirstName,
 LastName
 from Sales.Customers

 union all

 select 
 EmployeeID,
 FirstName,
 LastName
 from Sales.Employees


--Find the employees who are not customers at the same time
 select 
 EmployeeID,
 FirstName,
 LastName
 from Sales.Employees

 except

  select 
 CustomerID,
 FirstName,
 LastName
 from Sales.Customers


 -- Find the employees who are also in customers
  select 
 EmployeeID,
 FirstName,
 LastName
 from Sales.Employees

 Intersect

  select 
 CustomerID,
 FirstName,
 LastName
 from Sales.Customers


 /*
 Orders data are stored in separte 
 tables (orders and OrdersArchive).
 combine all orders data into one report without duplicate
 */

 select *
 from Sales.Orders
 union
 select * 
 from  Sales.OrdersArchive



 /*
=============================================================
=======================  Row Level Function =====================
=============================================================
 Row level calculaion                   Aggregation
 1. Single row Fucntion                  1. Multi-row function
    1. String                               1. Aggregate (Basic)
    2.Numeric                               2. Window (Advanced)
    3.Date & Time
    4. Null


*/

/*=====================================================
                    String Function
 Manipulation           Calculation         String Extraction
 Concat                   Len                  LEFT
 UPPER                                          RIGHT
 LOWER                                          SUBSTRING
 TRIM
 REPLACE
==============================================================*/

--Concatenate first name and country into one column
select 
CONCAT(first_name,'-',country),
UPPER(first_name) as uppercase,
LOWER(first_name) as lowercase,
LEN(first_name) as lengthnum,
len(TRIM(first_name)) as trimnum,
LEFT(first_name,3) as left_Name,
RIGHT(first_name,3) as right_name,
SUBSTRING(first_name,2,3) as substring_name
from customers

--Remove dashes (-) from a phone number
select
'123-456-789',
REPLACE('123-456-789','-','')

--Retrieve a list of customers first name after removing the first character
select 
first_name,
SUBSTRING(first_name,3,2)
from customers

/*=================================================================
                            Number Functions

 1.Round
 2.ABS( return the absolute(Positive) value of a number .removing any negative sign
===================================================================*/
 select
 3.516,
 ROUND(3.516,2) as round_2,
 ROUND(3.516,1) as round_1,
 ROUND(3.516,0) as round_0

 select
 -10,
 abs(-10)

 /*================================================================
                       Date & Time Functions
 Part Extraction     Format & Casting     Calculations   Validation 

 Day                   Format                 Dateadd         ISDATE
 MONTH                 CONVERT                DATEDIFF
 YEAR                  CAST
 DATEPART ( year, month,day,week,quarter)
 DATENAME
 DATETRUNC
 EOMONTH
 ==================================================================*/
 select
 OrderID,
 CreationTime,
 '2025-08-20' Hardcoded,
 GETDATE() today
 from Sales.Orders

 SELECT
 OrderID,
 CreationTime,
 YEAR(CreationTime) as Year,
 MONTH(CreationTime) as Month,
 DAY(CreationTime) as day
 FROM Sales.Orders

 select
 OrderID,
 CreationTime,
 DATEPART(year,CreationTime) as year,
 DATEPART(month,CreationTime) as month,
 DATEPART(day,CreationTime) as day,
 DATEPART(weekday,CreationTime) as week,
 DATEPART(quarter,CreationTime) as quarter,
 DATEPART(hour,CreationTime) as hour
 from Sales.Orders


select
OrderID,
CreationTime,
DATENAME(year,CreationTime) as year,
DATENAME(month,CreationTime) as month,
DATENAME(weekday,CreationTime) as weekday,
DATENAME(week,CreationTime) as week,
DATENAME(quarter,CreationTime) as quarter,
DATENAME(day,CreationTime) as day
from Sales.Orders

select
DATETRUNC(year,CreationTime) as year,
DATETRUNC(month,CreationTime) as month,
DATETRUNC(day,CreationTime) as day,
DATETRUNC(minute,CreationTime) as minute,
DATETRUNC(hour,CreationTime) as hour,
DATETRUNC(second,CreationTime) as second
from Sales.Orders

select
DATETRUNC(month,CreationTime) creation,
count(*)
from Sales.Orders
group by DATETRUNC(month,CreationTime)

select
DATETRUNC(year,CreationTime) creation,
count(*)
from Sales.Orders
group by DATETRUNC(year,CreationTime)

select 
OrderID,
EOMONTH(CreationTime)
from Sales.Orders

--how many orders were placed each year
select
year(OrderDate),
count(*) as NrOfOrders
from Sales.Orders
group by year(OrderDate)

--Show all orders that were placed during he month of february
select
*
from sales.Orders
where MONTH(OrderDate)=2
--=============================================================================

select
OrderID,
CreationTime,
FORMAT(CreationTime,'dd') as dd,
FORMAT(CreationTime,'ddd') as ddd,
FORMAT(CreationTime,'dddd') as dddd,
FORMAT(CreationTime,'MM') as mm,
FORMAT(CreationTime,'MMM') as mmm,
FORMAT(CreationTime,'MMMM') as mmmm
from Sales.Orders

--show creationtime using the following format:
--Day Wed Jan Q1 2025 12:34:56 PM

select
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime,'ddd MMM') +
' Q'+DATENAME(quarter,CreationTime) + ' ' +
FORMAT(CreationTime,'yyyy hh:mm:ss tt')
from Sales.Orders


select
OrderDate,
count(*)
from Sales.Orders
group by OrderDate

select 
FORMAT(OrderDate,'MMM yy') OrderDate,
count(*)
from Sales.Orders
group by FORMAT(OrderDate,'MMM yy')


----------------------------------------------------
select
CONVERT(int,'123')as [String to int convert],
CONVERT(date,'2025-08-20') as [String to date convert],
CreationTime,
CONVERT(date,CreationTime) as [DateTime to date convert]
from Sales.Orders

select 
cast('123' as int) as [string to int],
cast( 123 as varchar) as [int to string],
cast('2025-08-02' as date) as [string to date]

select
OrderID,
OrderDate,
DATEADD(day,-10,OrderDate) as tenDaysBefore,
DATEADD(month,3,OrderDate) as ThreeMonthLater,
DATEADD(year,2,OrderDate) as TwoYearLater
from Sales.Orders

--Calculate the age of employee
select
EmployeeID,
BirthDate,
DATEDIFF(year,BirthDate,GETDATE())
from Sales.Employees

-- Find the average shipping duration in days for each month
select
month(OrderDate) as ordermonth,
avg(DATEDIFF(day,OrderDate,ShipDate)) Day2Ship
from Sales.Orders
group by month(OrderDate)

-- Time Gap Analysis
--Find the number of days between each order and the previous order
select
OrderID,
OrderDate as CurrentOrderDate,
LAG(OrderDate) over(order by OrderDate) PreviousOrderDate,
DATEDIFF(day,LAG(OrderDate) over(order by OrderDate),OrderDate ) NeOFDays

from Sales.Orders


select
OrderDate,
ISDATE(OrderDate),
case when ISDATE(OrderDate) =1 then CAST(OrderDate as date)
end NewOrderDate
from
(
select '2025-08-20' as OrderDate union
select '2025-08-21' union
select '2025-08-23' union
select '2025-08'
)t
--- where ISDATE(OrderDate)=0
/*==========================================================
                              NULL Functions

        Replace Values                                                  Check for Nulls
        1.isnull (Replace null with a specified value)                          is null
        2.coalesce(Return the first non null value from a list                is not null
        3.nullif

================================================================*/

--Find the average scores of the customers
select 

Score,
AVG(Score) over() as avgScore,
AVG(coalesce(Score,0)) over() as new_avg_score
from Sales.Customers
group by Score

/*
Display the full name of customers in a single field
by merging their first and last names,
and add 10 bonus point  to each customers score
*/

select *,
FirstName+ ' '+coalesce(LastName,'') as fullname, 
coalesce(Score,0)+10
from Sales.Customers

--Sort the customers from lowest to highest scores
--with nulls appearing last
select 
Score,
coalesce(Score,9999999) as totalscore
from Sales.Customers
order by coalesce(Score,9999999)

select
Score
from Sales.Customers
order by case when Score is null then 1 else 0 end,Score

--Find the sales price for each order by dividing the sales by the quantity.
select
OrderID,
Sales,
Quantity,
Sales/nullif(Quantity,0) as Price
from Sales.Orders

--Identify the customers who have no scores
select
* 
from Sales.Customers
where Score is null

select
* 
from Sales.Customers
where Score is not  null

-- List all detaills for customers who have not placed any orders
select
c.*,
o.OrderID
from Sales.Customers as c
left join Sales.Orders as o
on c.CustomerID=o.CustomerID
where o.CustomerID is not null

/*=================================================================================
                         CASE STATEMENT
    Evaluates a list of condition and return 
    a value when the first condition is met

    Main purpose is data transformation
       Derive new  information
    -create new columns based on existing data

Categorizing Data
  Group the data into different categories based on certain conditions

Conditional Aggregation
  Apply aggregate function only as subsets of data that fulfill certain conditions
===================================================================================*/

/*
generate a report showing the total sales for each category:
-high: if the sales higher than 50
-Medium: if the sales between 20 and 50
-low : if the sales equal or lower then 20

sort the result from lowest to highest
*/

select
category,
sum(Sales) as ToalSales
from(
select
OrderID,
Sales,
case 
  when Sales >50  then 'High'
  when Sales >20 then 'Medium'
  else 'low'
end category
from Sales.Orders
)t
group by category

--Retrieve employee details with gender displayed as full text

select
EmployeeID,
FirstName,
LastName,
Gender,
case 
when Gender='F' then 'Female'
when Gender='M' then 'Male'
else 'Unknown'
end 
from Sales.Employees

--Retrieve customers details with abbreviated country code
select
CustomerID,
FirstName,
LastName,
Country,
case Country
when 'Germany' then 'GE'
when 'USA'    then 'US'
else 'UNKNOWN'
end
from Sales.Customers

/*
Find the average score of customers and treat nulls as 0
additionally provide details such customerID and LastName
*/

select
CustomerID,
LastName,
Score,
AVG(coalesce(Score,0)) over() as AvgScore
from Sales.Customers

select
CustomerID,
LastName,
Score,
avg(case 
    when Score is null then 0
    else Score
end ) over() Total_Avg
from Sales.Customers

--count how many times each customer has made 
--an order with sales greater than 30
select
OrderID,
CustomerID,
Sales
from Sales.Orders
order by CustomerID

select
CustomerID,
count(*)
from Sales.Orders
where Sales>30
group by CustomerID

/*=====================================================================
========================================================================
======================== Aggregation & Analytical Function =============
========================================================================
========================================================================
      1. Aggregations Fucntion
      2. Window Basic
      3. Window Aggregate Function
      4. Window Ranking function
      5. Window values function



Window Function
     Perform calculation on a specific sunset of data 
     without losing the level of details of rows.

     Aggregate                     Rank                  Value
    COUNT()                        Row_number             Lead
     sum()                        Rank()                 LAG()
     AVG()                        DENSE_RANK()           FIRST_VALUE()
     MIN()                        CUME_DIST()            
     MAX()                        PERCENT_RANK()
                                  NTILE()

*/

--Find the total sales across all orders

select
sum(Sales) as TotalSum
from Sales.Orders


--Find the total sales across each product
select
     ProductID,
     sum(Sales) as Total_Sales
from Sales.Orders
group by ProductID

--Find the total Saless for each products
--additionlly provide details such orders id & order date
select
OrderID,
OrderDate,
ProductID,
sum(Sales) over(partition by ProductID) as Total_Sale
from Sales.Orders
