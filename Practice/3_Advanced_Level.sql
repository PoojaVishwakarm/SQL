/*============================================================================
==============================================================================
                     Advanced SQl TECHNIQUES
==============================================================================
1. Subqueries
2.CTE
3.Views
4.CTAS Tables & Temp Tables
5.Stored Procedure
6.Triggers

===============================================================================
===============================================================================
 DATA WAREHOUSE
       A special databas that collects and integrates data from different sources 
       to enable analytics and support decision making.

DATABASE ENGINE
    It is the brain of the database, executing multiple operation
    such as storing ,retrieving, and managing data within the database.

DISK STORAGE
   Long term memory where data is stored parmanently.
    +Capacity: can hold a large amount of data
    -Speed:   slow to read and to write

CACHE STORAGE
       Fast short term memory where data is stored temporarily.

USER DATA STORAGE
      Its the main content of the database .This is where the 
      actual data that users care about is stored.

SYSTEM CATALOG
      Databases internal storage for its own information.
      A blueprint that keeps track of everything about the database
      itself not the user data.
      It holds the metadata information about the database.

METADATA
     data about data

INFORMATTION SCHEMA
     A system defined scheme with built in views
     that provide info about the databases like tables 
     and columns.

TEMP DATA STORAGE
      Temporyry space used by th databas for short-term
      tasks like processing queries or sorting data.
      Once these tasks are done the sorage is cleared.
================================================================================
================================================================================*/

select * from INFORMATION_SCHEMA.COLUMNS

select
distinct TABLE_NAME
from INFORMATION_SCHEMA.COLUMNS


/*====================================================================================
                  SUBQUERY
        A Query Inside Another Query


Step 1:   Join Tables
Step 2:   Filtering
Step 3:   Transformation
Step 4:   Aggregations

                                 Categories

                  ----------------Dependancy------------
                  |                                     |
         Non-Correlated Subquery                Correlated Subqury


                           Results Types 
                                 |
                    ----------------------------
                    |            |              |
       Scaler Subquery     Row Subquery      Table Subquery
               

               Location|Clauses
                1.select
                2. from
                3. join
                4. where     1. comparsion operators (<,>,=,!=,>=,<=)
                             2. Logical operatos    ( IN,ALL,ANY,EXISTS)

======================================================================================*/

--SCALAR QUERY
 select 
 AVG(Sales)
 from Sales.Orders


 --Row QUERY( Multiple Rows & single column)

 select
 CustomerID
 from Sales.Orders


 --Table Query( Multiple rows & multiple columns)

 select
 OrderID,
 OrderDate
 from Sales.Orders
/*==============================================================================
FROM SUBQUEERY
     -- USED as tempoarary table for the main query
================================================================================*/

/* Task: Find the products that have a price
          higher than the average price of all products 
*/
select
*
from
    (
    select
    ProductID,
    Price,
    AVG(Price) over() AvgPrice
    from Sales.Products
    )t 
where Price>AvgPrice

--Rank customers based on their total amount of sales
select
*,
RANK() over(order by TotalSales desc)  rn
from
    (
    select
    CustomerID,
    sum(Sales)  TotalSales
    from Sales.Orders
    group by CustomerID 
    )t

/*=======================================================================
SELECT SUBQUERY
   Used to aggregate data side by side with the main 
   query's data allowing for direct comparison.
=========================================================================*/


--Show the products  IDs name price and total number of orders
---Main Query(Scaler subquery)
select
ProductID,
Product,
Price,
-- Subquery
(select count(*) from Sales.Orders) as TotalOrders
from Sales.Products

/*=======================================================================================
JOIN SUBQUERY
   used to prepare the data (Filtering or aggregation) before
   joining it with other tables.
=========================================================================================*/

--Show all customers details and find the total orders for each customers
select
*
from Sales.Customers as c
left join (
    select 
    CustomerID,
    count(*) TotalOrders
    from Sales.Orders
    group by CustomerID ) o
on c.CustomerID=o.CustomerID

/*======================================================================================
WHRE SUBQUERY
  Used for complex filtering logic and makes query more 
  flexible and dynamic.
=========================================================================================*/

--Find  the products that have a price higher than the average pric of all products
select
*
from
(
select
ProductID,
Price,
AVG(Price) over() AvgPrice
from Sales.Products
)t
where Price>AvgPrice

select
ProductID,
Price
from Sales.Products
where Price> (select AVG(Price) from Sales.Products)

/*===================================================================================================
IN OPERATOR
  Checks whether a value matches any values from a list

=====================================================================================================*/

--Show the dtails of orders made by customrs in germany
select *
from Sales.Orders
where CustomerID in (
                        select CustomerID from Sales.Customers
                        where Country='Germany')

--Show the dtails of orders made by customers in not in grmany
select
*
from Sales.Orders
where CustomerID in (select 
                        CustomerID
                        from Sales.Customers
                        where Country !='Germany')

/*===========================================================================================================
ANY OPERATOR
   Check if a values matches any value within a list
   Used to check if a value is true for at leat one of the values in a list
=============================================================================================================*/


--Find female employee whose salaries are greater
-- than the salaries of any male employees

select *
from Sales.Employees
where Salary > any (
                    )


select
EmployeeID,
FirstName,
Salary
from Sales.Employees
where Gender='F'
and Salary> any (select Salary from Sales.Employees where Gender='M')

/*================================================================================================================
ALL OPERATOR
  Checks if a values matches all  values within a list
==================================================================================================================*/

--Find female employees whose salaries are greater then the salaries of all male employees
select
EmployeeID,
FirstName,
Salary
from Sales.Employees
where Gender='F'
and Salary> all (select Salary from Sales.Employees where Gender='M')


/*===========================================================================================================
NON-CORRELATED SUBQUERY
  A subquery that can run indepndtly from the main qury

CORRELATED SUBQUERY
   A subquery that relayes on values from the main query
=====================================================================================================*/


--1---show all customer details and find the total orders of each customers
select
*,
(select count(*) from Sales.Orders o where o.CustomerID=c.CustomerID) TotalSales
from Sales.Customers c

--2-- Show the details of order made by customers in germany
select
*
from Sales.Orders o 
where exists (select *
              from Sales.Customers c
              where Country='Germany'
              and o.CustomerID=c.CustomerID)

select
*
from Sales.Orders o
where not exists (select *
              from Sales.Customers c
              where Country='Germany'
              and o.CustomerID=c.CustomerID)

/*========================================================================================================
==========================================================================================================
==========================================================================================================
                         COMMON TABLE EXPRSSION
                
    Temporary named result set(virtual table) that can be used 
    multiple times within your query to simplify and organize complex query.
===========================================================================================================
   step 1. join
   step 2. aggregations
   step 3. aggregations
===================================================================================================================
                                        CTE types
                                            |
                     ---------------------------------------------
                     |                                           |
                  NONE-RECURSIVE CTE                           RECURSIVE CTE
                          |
            ---------------------------
            |                          |
        STANDALONE CTE             NESTED  CTE

NON-RECURSIVE CTE
  is execited only once without any repetition.

RECURSIVE CTE
 Self-referencing query that repeatedly processes data until a specific condition is met.

STANDALONE CTE
  Defined and used independently
  Runs independently as its self contained and doesn't rely on other cte or queries.

NESTED CTE
   CTE inside another CTE
   A nested CTE uses the results of another CTE so it can't run independently.
==================================================================================================================*/
        
--step 1. Find the total sales per customer ( STANDALONE CTE  )
with CTE_total_Sales as 
(
select
CustomerID,
SUM(Sales) as TotalSales
from Sales.Orders
group by CustomerID
)
--Step 2 : Find the last orders date for each customer( STANDALONE CTE  )
,CTE_Last_Order as 
(
 select 
 CustomerID,
 MAX(OrderDate) as Last_Order
 from Sales.Orders
 group by CustomerID
 )
 -- Step 3: Rank customers based on total sales per customers(NESTED CTE)
 , CTE_Customers_Rank as
 (
 select
 CustomerID,
 TotalSales,
 rank() over(order by TotalSales desc) as CustomerRank
from CTE_total_Sales
)
-- Step 4 : segment customers based on thir total sales
,CTE_Customer_Segments as 
(
select
CustomerID,
case when TotalSales >100 then 'High'
     when TotalSales > 80 then 'Medium'
     else 'Low'
end CusTomerSegment
from CTE_total_Sales
)
-- Main query
select
c.CustomerID,
c.FirstName,
c.LastName,
ccr.CustomerRank,
cts.TotalSales,
cts_1.Last_Order,
ccs.CusTomerSegment
from Sales.Customers as c
left join CTE_total_Sales cts
on cts.CustomerID=c.CustomerID
left join CTE_Last_Order cts_1
on cts_1.CustomerID=c.CustomerID
left join CTE_Customers_Rank ccr
on ccr.CustomerID=c.CustomerID
left join CTE_Customer_Segments ccs
on ccs.CustomerID=c.CustomerID


----------------------------------------------------------------------------------------------------
------------------------------- Recursive CTE-------------------------------------------------------
----------------------------------------------------------------------------------------------------

with Series as (
        -- Anchor Query
        select
        1 as MyNumber
        union all
        -- Recursive Query
        select
        MyNumber +  1
        from Series
        where MyNumber <20
)
--main Query
select * from Series

/*
Show the employee hierarchy by displaying each
employee's level within the organization
*/
with CTE_Emp_Hierarchy as
(
-- Anchor Query
    select
        EmployeeID,
        FirstName,
        ManagerID,
        1 as Level
    from Sales.Employees
    where ManagerID is null
    union all
    --Recursive Query
    select
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    from Sales.Employees as e
    inner join CTE_Emp_Hierarchy ceh
    on e.ManagerID=ceh.EmployeeID
)
--main query
select
* 
from CTE_Emp_Hierarchy

/*=================================================================================================================
===================================================================================================================
===================================================================================================================
                                      Views
===================================================================================================================
DATABASE SERVER
  Stores ,managers and provides access to databases fro users or applications.

DATABASE
   Collections of information that is stored in a structured way.

SCHEMA
    Logical layer that groups related objects together.

TABLE
   A place where data is stored and organized into rows and columns.

VIEW
  is a virtual table that shows data without storing it physically.

DDL( DATA DEFINITION LANGUGE)
   A set of commands that allows us to define and manage the structure of a database.
   -Create
   -Alter
   -drop
 =======================================================================================================================
                                  Physical Level  ( DBA )                                                   | PHYSICAL LAYEY
                                      |                                                                     |  
                                      | ( DATA FILES ,PARTITIONS , LOGS , CATALOG , BLOCKS , CACHES )       |    INTERNAL
                                      |                                                                     |
                                      |                          
-------------------------------------------------------------------------------------------------------------------------------------
                                 LOGICAL LEVEL  ( APP DEVELOPER  DATA ENGINEER )                            | LOGICAL LAYER
                                      |                                                                     |  
                                      | ( TABLES , RELATIONSHIPNS , VIWES , INDEXES, PROCEDURES, FUNCTIONS )|    CONCEPTUAL
                                      |                                                                     |
                                      |                     
        --------------------------------------------------------------------------------------------------------------------------------------
                                   VIEWS LAYER     ( BUSNINESS ANALYSIS POWER BI                                                          |   VIEW LAYER
                                     |                                                                       |
                                     |                                                                       |  EXTERNAL
                                     |                                                                       
                                     |
============================================================================================================================
VIEWS USE CASE
    1. VIEWS CAN BE USE TO HIDE THE COMPLEXITY OF DATABASE TABLES AND OFFERS USERS MORE FRIENDLY AND EASY TO CONSUME OBJECTS.
   
   2.SECURITY
       use views to enforce security and protect senditive data by hiding column and or rows from tables.

   3.FLEXIBILITY & DYNAMIC
   4.MULTIPLE LANGUAGES
   5.VIRTUAL DATA MARTS IN DWH
     views can be used as data marts in data warehouse system because they provide a flexible and efficient way to present data.
=================================================================================================================================
CENTRAL QUERY LOGIC
  Stor central complex query in the database 
  for access by multiple queries reducing project complexity.
=========================================================================================================================*/

---===== #  USE CASE   central complex query logic

--Find the running total of slaes for rach month
with CTE_Monthly_Summary as (
select 
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
from Sales.Orders
group by DATETRUNC(month,OrderDate)
)
select
OrderMonth,
TotalSales,
sum(TotalSales) over(order by OrderMonth) as RunningTotal
from  CTE_Monthly_Summary

create view V_Monthly_Summary as
(
select 
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
from Sales.Orders
group by DATETRUNC(month,OrderDate)
)

select * from V_Monthly_Summary

drop view V_Monthly_Summary 

IF OBJECT_ID ('Sales.V_Monthly_Summary' ,'v') is not null
drop view Sales.V_Monthly_Summary
go
create view Sales.V_Monthly_Summary as
(
select 
DATETRUNC(month,OrderDate) OrderMonth,
SUM(Sales) TotalSales,
COUNT(OrderID) TotalOrders,
SUM(Quantity) TotalQuantities
from Sales.Orders
group by DATETRUNC(month,OrderDate)
)

--TASK: provide view that combines details from orders products customers and employees
 create view Sales.V_Order_Details as (
 select
  o.OrderID,
  o.OrderDate,
  o.Sales,
  o.Quantity,
  p.Product,
  p.Category,
 coalesce( c.FirstName,' ')+ ' '+coalesce(c.LastName,' ') CustomerName ,
 c.Country CustomerCountry,
 e.Department,
 coalesce( e.FirstName,' ')+ ' '+coalesce(e.LastName,' ') EmployeeName 
 from Sales.Orders o
  left join Sales.Products p
  on o.ProductID=p.ProductID
  left join Sales.Customers c
  on c.CustomerID=o.CustomerID
  left join Sales.Employees e
  on e.EmployeeID=o.SalesPersonID
  )

  select * from Sales.V_Order_Details

  /*
  Provides a view for the EU Sales Team 
  that combine details from all tables
  and excludes data related to the USA
  */

create view Sales.V_Order_Details_EU as (
 select
  o.OrderID,
  o.OrderDate,
  o.Sales,
  o.Quantity,
  p.Product,
  p.Category,
 coalesce( c.FirstName,' ')+ ' '+coalesce(c.LastName,' ') CustomerName ,
 c.Country CustomerCountry,
 e.Department,
 coalesce( e.FirstName,' ')+ ' '+coalesce(e.LastName,' ') EmployeeName 
 from Sales.Orders o
  left join Sales.Products p
  on o.ProductID=p.ProductID
  left join Sales.Customers c
  on c.CustomerID=o.CustomerID
  left join Sales.Employees e
  on e.EmployeeID=o.SalesPersonID
  where c.Country !='USA'
  )
  select * from Sales.V_Order_Details_EU


/*===============================================================================================================================================
=================================================================================================================================================
                              CTAS & TEMP
=================================================================================================================================================
CTAS--create table as select
  create a new table based on the result of an sql query.

TEMPORARY TABLES
   stores intermediate results in temporary storage within the database during the session.
   the database will drop all temporary tables once the session ends.
=================================================================================================================================================
BD TABLE
     A table is a structured collection of data similar to a spreadsheet or grid(Excel).

                                  TABLE TYPES
                                        |
                              ----------------------------
                              |                         | 
                       PERMANENT TABLE              TEMPORARY TABLE
                             |
                  --------------------------
                  |                        |
               CREATE/SELECT             CTAS
================================================================================================================================================

USE CASE 
   1.OPTIMIZE PERFORMANCE
   2.CREATING A SNAPSHOT
   3.PHYSICAL DATA MARTS IN DWH
     persisting the data marts of a dwh improves the speed of data retrieval
     compared to using views.

========================================================================================================================================================
 TEMP USE CASE
   1. Intermediate Results  
===========================================================================================================================================================
=============================================================================================================================================================*/

--# USE CASE  -------------OPTIMIZE PERFORMANCE

if OBJECT_ID('Sales.MonthlyOrders','U') is not null
drop table Sales.MonthlyOrders

go
select
DATENAME(month,OrderDate) OrderMonth,
count(OrderID) TotalSales
into Sales.MonthlyOrders
from Sales.Orders
group by DATENAME(month,OrderDate)

select * from  Sales.MonthlyOrders

drop table Sales.MonthlyOrders

--====================== temp table =======================================================================================================
 select
 *
 into #Orders
 from Sales.Orders

 select * from #Orders

 delete from #Orders
 where OrderStatus='Delivered'

 select
 *
 into Sales.OrdersTest
 from #Orders
 
 
 /*======================================================================================================================================
 ========================================================================================================================================
                                          Stored Procedures
 ========================================================================================================================================
 
 PARAMETERS
   placeholders used to pass values as input from the caller to the procedure, allowing dynamic data to be processed.

VARIABLES
  placeholders used to store values to  used later in the procedures.

parameters pass values into a stored procedue or return values back to the caller.
variables temporarily store and manipulate data during its execution.


 ========================================================================================================================================
 ========================================================================================================================================*/


 --Step 1: Write a Query
 -- For us customers find the total number of customers and the average score
 select
 COUNT(*) TotalCustomers,
 AVG(Score) AvgScore
 from Sales.Customers
 where Country='USA'
 
 --Step 2: turning the query into a stored procedure
 create procedure GetCustomerSummary 
 as 
 begin
 select
      COUNT(*) TotalCustomers,
     AVG(Score) AvgScore
 from Sales.Customers
 where Country='USA'
 end

 --step 3: Execute the stored procedure
 exec GetCustomerSummary
 /*====================================================================================*/
 --Define Stored Procedure




alter  PROCEDURE GetCustomerSummary 
    @Country NVARCHAR(50)='USA'
AS
BEGIN
        begin try

                declare @TotalCustomers int,@AvgScore float;
                --================================================
                --step 1: Prepare & Cleanup Data
                --================================================
                IF EXISTS (select 1 from Sales.Customers where Score is  null and Country=@Country)
                BEGIN
                      print('updating null scores to 0');
                      update Sales.Customers
                      set Score=0
                      where Score is null and Country=@Country;
                END

                ELSE
                BEGIN
                     print('no null scores found')
                END
                --==============================================
                --step 2: Generating reports
                --==============================================
                -- calculate total customers and average score for specific country  
                  SELECT
                        @TotalCustomers =COUNT(*) ,
                        @AvgScore=AVG(Score) 
                    FROM Sales.Customers
                    WHERE Country = @Country;

                print 'Total customers from '+@Country+ ':' + cast(@TotalCustomers as nvarchar);
                print 'Average Score from ' +@Country + ':' + cast(@AvgScore as nvarchar);
                --
                --calculate total nuber of orders and total sales for specific country
                -- Find th total NR. of orders and total sales
                select
                count(*) TotalCustomers,
                SUM(Sales) TotalSales
                from Sales.Orders o
                join Sales.Customers c
                on c.CustomerID=o.CustomerID
                where c.Country=@Country;

        end try
        begin catch
           print('An error occured.');
           print('Error Message:' + error_message());
           print('error number:' +cast(error_number() as nvarchar));
           print('error Line:'+ cast(error_line() as nvarchar));
           print('error procedure' + error_procedure());
        end catch

END
GO

EXEC GetCustomerSummary @Country = 'Germany';

EXEC GetCustomerSummary 

DROP PROCEDURE IF EXISTS GetCustomerSummary;
GO
   

/*===========================================================================================================================
=============================================================================================================================
                                      TRIGGERS
=============================================================================================================================
TRIGGERS
    SPECIAL STORED PROCEDURE(SET OF STATEMENTS) THAT AUTOMATICALLY RUNS IN
    RESPONSE TO A SPECIFIC EVENT ON A TABLE OR VIEW.

=============================================================================================================================
   TRIGGERS TYPES
    1. DML (INSERT,UPDATE,DELETE)
    2. DDL (CREATE,ALTER,DROP)
    3. LOGGON

=============================================================================================================================*/

CREATE TABLE Sales.EmployeeLogs(
     LogID int identity(1,1)  primary key,
     EmployeeID int,
     LogMessage varchar(255),
     LogDate date
 )

 create trigger trg_afterInsertEmployee on Sales.Employees
 after insert
 as 
 begin
 insert into Sales.EmployeeLogs(EmployeeID,LogMessage,LogDate)
    select 
         EmployeeID,
         'New Employee Added='+ cast(EmployeeID as varchar),
         GETDATE()
    from inserted
     
 end 


 insert into Sales.Employees values
 (7,'maria','Doe','HR','1988-01-12','F',80000,3)


 select * from Sales.EmployeeLogs