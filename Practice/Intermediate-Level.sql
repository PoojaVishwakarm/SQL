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
--Find the total sales across all orders
--Find the total sales for each combinaion of product and order status
--additionlly provide details such orders id & order date
select
OrderID,
OrderDate,
ProductID,
OrderStatus,
SUM(Sales) over() as TotalSales,
sum(Sales) over(partition by ProductID) as Total_Sale,
SUM(Sales) over(partition by ProductID, OrderStatus) as SalesByProductAndStatus

from Sales.Orders


/*
Rank each order based on their sales from highest to lowest
additionally provide details such order Id & order Date
*/

select
OrderID,
OrderDate,
Sales,
ProductID,
rank() over(partition by ProductID order by Sales desc) as Total_Rank
from Sales.Orders


--Rank Customers based on thier total sales
select
CustomerID,
sum(Sales) TotalSales,
rank() over(order by sum(Sales) desc) RankCustomers
from Sales.Orders
group by CustomerID


--==============================================================================
--                         Window Aggregate Function
--==============================================================================


--Find the total number of orders
--Find the total number of orders for each customers
--Additionally provide details such order ID, order Date

select
OrderID,
OrderDate,
count(*) over() TotalOrders,
count(*) over(partition by CustomerID) Total_Customer_Order
from Sales.Orders

--Find the total number of customer
--Find the total number of score for the customers
--Additionally provide all customers details

select
*,
count(Score) over() TotalCustomers,
COUNT(*) over() Totalcustomers
from Sales.Customers


--Check whether the table orders contains any duplicate rows
select 
OrderID,
count(*) over(partition by OrderID) CheckPK
from Sales.Orders

select
*
from (
select
OrderID,
count(*) over(partition by OrderID) checkPK
from Sales.OrdersArchive
)t where checkPK >1

/*
1. Overall Analysis
2.Category Analysis
3. Quality Checks: Identify Nulls
4. Quality Checks: Identify Duplicates
*/



--Find the total sales acros  all ordes
--and the total sales for each product
--Additionally provide details such order Id order Date

select 
OrderID,
ProductID,
Sales,
sum(Sales) over() TotalSales,
sum(Sales) over(partition by ProductID) TotalSalesProduct
from Sales.Orders
  

--Find the percentage contribution of each products sales to the total sales
select
OrderID,
ProductID,
Sales,
sum(Sales) over() TotalSales,
round(cast(Sales as float) /sum(Sales) over() *100,3)
from Sales.Orders

--Find the average sales across all orders
--and the average sales for each product.
--Additionally  provide details such as order ID and orders Date

select
OrderID,
OrderDate,
Sales,
avg(Sales) over() AvgTotal,
AVG(Sales) over(partition by ProductID) avgProducts
from Sales.Orders

--Find the average  scores of customers.
--Additionally provides details such as customers Id and Last Name
select
CustomerID,
LastName,
Score,
AVG(case 
      when Score is null then 0
      else Score
      end)  over() AvgScore
from Sales.Customers

--Find all orders where sales are higher than the
-- average sales across all orders.
select
*
from
(
    select
        OrderID,
        OrderDate,
        Sales,
        AVG(Sales) over() avgSales
    from Sales.Orders
)t
where Sales>avgSales

/*
Find the highest & Lowest sales across all orders
and the highest & lowest sales for each products.
additionally provide details such as order Id and Orders Date
*/

select
OrderID,
OrderDate,
Sales,
MIN(Sales) over()as Min_Values,
MAX(Sales) over() as Max_Values,
MIN(Sales) over(partition by ProductID) as Min_Product,
MAX(Sales) over(partition by ProductID) as Max_Products
from Sales.Orders

--Show the employees with the highest salaries
select *
from  
(
select*,
max(Salary)  over() highestSalary
from Sales.Employees
)t
where Salary=highestSalary

--Find the deviaion of each sales from the mininum and maxmum sales amounts
select
OrderID,
OrderDate,
ProductID,
Sales,
max(Sales) over() highestSales,
min(Sales) over() LowestSales,
 max(Sales) over()-Sales ,
Sales -min(Sales) over()
from Sales.Orders

/*
Running Total
  Aggregate all values from the beginning up to the current 
  point without dropping off  older data

Rolling Total
  Aggregate all values within a fixed time window(30 day)
  as new data is added the oldest data point will be dropped.
*/

--Calculate the moving average of sales for each product over time
select
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) over(partition by ProductID) avgProdust,
    AVG(Sales) over(partition by ProductID order by OrderDate asc)

from Sales.Orders

--Calculate the moving average of sales for each
--product over time, including only the next order
select
OrderID,
OrderDate,
ProductID,
Sales,
AVG(Sales) over() Total_avg,
AVG(Sales) over(partition by ProductID order by OrderDate) moving_Avg,
AVG(Sales) over(partition by ProductID order by OrderDate rows between current row and 1 following) moving_avg_1 
from Sales.Orders

--==========================================================================================================================
--         Row_number()
--             Assign a unique number to each row
--             Is doean't handle ties
--             unique ranking wthout gaps/skipping
--============================================================================================================================

--Rank the orders based on thier sales from highest to lowest
select
OrderID,
ProductID,
Sales,
row_number() over( order by Sales desc) moving_rank
from Sales.Orders


/*===========================================================================
                   Rank()
                Assign a rank to each row
                it handles ties
                it leaves gaps in ranking
======================================================================================*/

select
OrderID,
ProductID,
Sales,
row_number() over( order by Sales desc) moving_row_number,
rank() over(order by Sales desc) SalesRank_Rank
from Sales.Orders



/*===========================================================================
                   DENSE_Rank()
                Assign a rank to each row
                it handles ties
                it doesn't leaves gaps in ranking
======================================================================================*/
select
OrderID,
ProductID,
Sales,
row_number() over( order by Sales desc) moving_row_number,
rank() over(order by Sales desc) SalesRank_Rank,
DENSE_RANK() over(order by Sales desc) SaleRank_Dense
from Sales.Orders


--=================== Interger-Based Ranking Comparision================

-- Row_Number use case    TOP-N ANALYSIS


--FIND THE TOP HIGHEST SALES FOR EACH PRODUCT
select
*
from
(
select
OrderID,
ProductID,
Sales,
ROW_NUMBER() over(partition by ProductID order by Sales desc) RankByProduct
from Sales.Orders
)t where RankByProduct=1

-- Row_Number use case    BOTTOM-N ANALYSIS

--Find the lowest 2 customers based on thier total sales
select
*
from
(
select
CustomerID,
SUM(Sales) TotalSales,
ROW_NUMBER() over(order by sum(Sales)) RankCustomers
from Sales.Orders
group by CustomerID
)t where RankCustomers<=2

-- Row_Number use case    GENERATE UNIQUE IDs

--Assign unique IDs to the rows of the 'orders archive' table

select
ROW_NUMBER() over(order by OrderID,OrderDate) UniqueID,
* 
from Sales.OrdersArchive

/*
Paginating
  The process of breaking down a large 
  data into smaller, more manageable chunks
*/

-- Row_Number use case    IDENTIFY DUPLICATES
-- Identify and remove duplicate rows to improve data quality.

--Identify duplicate rows in the table 'OrdersArchive'
-- and return a clean result without any duplicates
select
*
from(
select 
ROW_NUMBER() over(partition by OrderID order by CreationTime desc) rn,
*
from Sales.OrdersArchive
)t where rn=1

select
*
from(
select 
ROW_NUMBER() over(partition by OrderID order by CreationTime desc) rn,
*
from Sales.OrdersArchive
)t where rn>1







select
*
from
(
select
OrderID,
ProductID,
Sales,
ROW_NUMBER() over(partition by ProductID order by Sales asc) as RankByProduct_1
from Sales.Orders
)t
where RankByProduct_1>1


/*===============================================================================================
                       NTILE()
        Divides the row into a specified number of
        approximately equal groups(Buckets)

==================================================================================================*/
select
OrderID,
Sales,
NTILE(3) over(order by Sales desc) ThreeBucket,
NTILE(2) over(order by Sales desc) TwoBucket,
NTILE(1) over(order by Sales desc) OneBucket
from Sales.Orders


-- NTILE use case DATA SEGMENTATION

/*
     DATA SEGMENTATION
     Divides a dataset into distinct subsets
     based on certain crieria
*/

 
--Segment all orders into 3 categories:high medium and low sales.
select
OrderID,
Sales,
NTILE(4) over(order by Sales desc) Buckets,
NTILE(3) over(order by Sales desc) Buckets,
NTILE(2) over(order by Sales desc) Buckets,
NTILE(1) over(order by Sales desc) Buckets
from Sales.Orders

--Segment all orders into 3 categories : high medium and low
select
*,
case when Buckets=1 then 'high'
     when Buckets=2 then 'Medium'
     when Buckets=3 then 'low'
end SalesSegmentations

from
(

select
OrderID,
Sales,
NTILE(3) over(order by Sales desc) Buckets
from Sales.Orders
)t

-- NTILE use case EQUALIZING LOAD

--In order to export the data divide the order into 2 groups
select
NTILE(2) over(order by OrderID) Buckets,
*
from Sales.Orders


/*=============== Percentage-Based Ranking ==========================
           POSITION NR                                   POSITION NR-1
CUME_DIST=--------------                 PERCENT_RANK=----------------
           NUMBER OF ROWS                                NUMBER OF ROWS -1


CUME_DIST
  Cumulative Distribution calculates the distribution
  of data points within a window.

PERCENT_RANK()
   Calculates the relative position of each row
*/

--Find the products that fall within the highest 40% of prices
select
*,
CONCAT(DistRank*100,'%')  DistRankPerc
from (
select
    Product,
    Price,
    CUME_DIST() over(order by Price desc) DistRank
from Sales.Products
 )t
 where DistRank<0.4


 /*=============================================================================================
 =======================================================================================================
                           Window Value Function
=========================================================================================================
=========================================================================================================
LEAD()
      Accsess a value from the next row within a window
LAG() 
      Acess a value from the previous row within a window
 
FIRST_VALUE()
     Access a value from the first row within a window
LAST_VALUES()
     Access a value from the last row within a window






===========================================================================================================*/

/*=========================================================================================================
TIME SERIES ANALYSIS
   The process of analyzing the data to understand patterns,
   trends,and behaviours over time

          YEAR-OVER-YEAR(YOY)
              Analyze the overall growth or decline of the 
              business's performance over time
        MONTH-OVER-MONTH(MOM)
              Analyze short ter trends and discover patterns in seaconality.
=============================================================================================================*/


-----VALUE WINDOW FUNCTIONS    ======= MIN/MAX

--Analyze the month over month performance by finding th percentange change
-- in sales between the current and previous months
select
*,
CurrentMonthSales-PreviousMonthSales as MoM_Change,
round(cast((CurrentMonthSales-PreviousMonthSales)as float)/PreviousMonthSales*100,1) as MOM_perc
from
(
select
MONTH(OrderDate) as OrdrMonth,
sum(Sales) as CurrentMonthSales,
LAG(sum(Sales)) over(order by MONTH(OrderDate)) PreviousMonthSales
from Sales.Orders
group by MONTH(OrderDate)
)t

/*=====================================================================================
CUSTOMER RETENTION ANALYSIS
   Measure customers behavior and loyalty to help
   businesses build strong relationships with customers

========================================================================================*/

--In order to analyze customers loyalty
--rank customers based on the average days between thier orders.
select
CustomerID,
AVG(DaysUnitsNextOrder) AVGDays,
RANK() over(order by coalesce(AVG(DaysUnitsNextOrder),99999999)) Rankavg
from
(
select
OrderID,
CustomerID,
OrderDate CurrentOrder,
LEAD(OrderDate) over(partition by CustomerID order by OrderDate) NextOrder,
DATEDIFF(day,OrderDate,LEAD(OrderDate) over(partition by CustomerID order by OrderDate)) DaysUnitsNextOrder
from Sales.Orders
)t
group by CustomerID

--Find the lowest and highest sales for each product
 select
 OrderID,
 ProductID,
 Sales,
 FIRST_VALUE(Sales) over(partition by ProductID order by Sales) LowestSales,
 LAST_VALUE(Sales) over(partition by ProductID order by Sales
 rows between current row and unbounded following) HighestSales,
 FIRST_VALUE(Sales) over(partition by ProductID order by Sales desc) HighestSales_1
 from Sales.Orders


 --Find the lowest and highest sales for each product
 --Find the difference in  sales between the current and the lowest sales
 select
 OrderID,
 ProductID,
 Sales,
 FIRST_VALUE(Sales) over(partition by ProductID order by Sales) LowestSales,
 LAST_VALUE(Sales) over(partition by ProductID order by Sales
 rows between current row and unbounded following) HighestSales,
 Sales- FIRST_VALUE(Sales) over(partition by ProductID order by Sales)  as SalesDifference
 from Sales.Orders


  