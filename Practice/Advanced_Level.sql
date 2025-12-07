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
---Main Query
select
ProductID,
Product,
Price,
-- Subquery
(select count(*) from Sales.Orders) as TotalOrders
from Sales.Products