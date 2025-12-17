/*====================================================================================================
======================================================================================================
                       Performance Optimization
                       1. Indexes
                       2.Partitions
                       3.Performance Tipes
======================================================================================================
INDEX
  data structure provides quick access to data optimizing the speed of your queries.

======================================================================================================
                                     INDEXES
                                        |
                   -------------------------------------------
                   |                    |                     |
                STRUCTURE             STORAGE                 FUNCTIONS
          CLUSTERED INDEX          ROWSTORE INDEX           UNIQUE INDEX
      NON-CLUSTERED INDEX        COLUMNSTORE INDEX          FILTERED INDEX
======================================================================================================
PAGE
  THE SMALLEST UNIT OF DATA STORAGE IN A DATABASE(8 KB)
  IT STORE ANYTHING(DATA ,METADATA,INDEXES,ETC)
  
TYPES
   1.DATA PAGE
   2.INDEX PAGE


==================================================================================================================
CLUSTERED INDEX
 B-TREE
   hierarchical structure storing data at leaves to help quickly locate data.

COMPOSITE INDEX
  
==================================================================================================================*/
select* 
into Sales.DBCustomers
from Sales.Customers

create clustered index idx_DBCustomers_CustomerID
on Sales.DBCustomers (CustomerID)

drop index idx DBCustomers CustomerID on Sales.DBCustomers


----------------------------------------------------------------------
-------------------------------------------------------------------------------
create nonclustered index idx_DBCustomers_LastName
on Sales.DBCustomers (LastName)

create nonclustered index idx_DBCustomers_FirstName
on Sales.DBCustomers (FirstName)


-----------------------------------------------------------------------------------
------------------------ COMPOSITE INDEX ------------------------------------------------------------------
---------------------------------------------------------------------------------------------
 select *
 from Sales.DBCustomers
 where Country='USA' and Score > 500

 create index idx_DBCustomers_CountryScore
 on Sales.DBCustomers(Country,Score)

 ------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------------------
 create clustered columnstore index idx_DBCustomers_CS
 on Sales.DBCustomers

 drop index idx_DBCustomers_CS
 on Sales.DBCustomers

  create nonclustered columnstore index idx_DBCustomers_CS
 on Sales.DBCustomers

 drop  index idx_DBCustomers_CustomerID on Sales.DBCustomers

 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 use AdventureWorksDW2022
 --HEAP
 select *
 into FactInternetSales_HP
 from FactInternetSales

 --ROWS
  select *
 into FactInternetSales_RS
 from FactInternetSales


 create clustered index idx_FactInternetSales_RS_PX
 on FactInternetSales_RS(SalesOrderNumber,SalesOrderLineNumber)

  --COLUMNS
  select *
 into FactInternetSales_CS
 from FactInternetSales


 create clustered columnstore index idx_FactInternetSales_CS_PX
 on FactInternetSales_CS

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
                     --  UNIQUE INDEX
                     --    ensures no duplicates values exist in specific columns

                    --     Benefits
                       --   1. Enforce uniqueness.
                        --  2.Slightly increase query performance
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
/* 
              PERFORMANCE
                 Writing to an unique index is slower then non-unique.
                 Reading from an unique index is faster than non-unique.

*/

--======================== unique index ================================================================================
use SalesDB


select * from Sales.Products

create unique nonclustered index idx_Products_Product
on Sales.Products(Product)


--========================  Filtered index ==============================================================================
-- An index that includes only rows meeting the specified conditions
-- BENEFITS    1. TARGETED OPTIMIZATION
--             2. Reduce Storage: Less data in the index

select * from Sales.Customers
where Country='USA'

create nonclustered index idx_Customers_Country
on Sales.Customers (Country)
where Country='USA'


/*======================== INDEX MANAGEMENT & MONITORING =======================================
         1. MONITOR INDEX USAGE
         2. MONITOR MISSING INDEXEX
         3. MONITOR DUPLICATES INDEXES
         4. UPDATE STATISTICS
         5. MONITOR FRAGMENTATION


*/

--LIST ALL INDEXES ON A SPECIFIC TABLE
sp_helpindex 'Sales.DBCustomers'

------------------------------ 1. MONITOR INDEX USAGE
select 
    tbl.name as TableName,
    idx.name as IndexName,
    idx.type_desc as IndexTypes,
    idx.is_primary_key as IsPrimaryKey,
    idx.is_unique as IsUnique,
    idx.is_disabled as IsDiasbled,
    s.user_seeks as userseek,
    s.user_scans as userscans,
    s.user_lookups  as userlookups,
    s.user_updates  as userupdates,
    coalesce( s.last_user_seek,s.last_user_scan) LastUpdate
from sys.indexes idx
join sys.tables tbl
on idx.object_id=tbl.object_id
left join sys.dm_db_index_usage_stats s
on s.object_id=idx.object_id
and s.index_id=idx.index_id
order by  tbl.name ,idx.name



select * from sys.tables

select * from sys.dm_db_index_usage_stats

------------------------------------------------------------------------------------------------------------
-----------------------------------   2. MONITOR MISSING INDEXEX






select * from sys.dm_db_missing_index_details


------------------------------------------------------------------------------------------------------------
-----------------------------------    3. MONITOR DUPLICATES INDEXES
select
tb1.name as TableName,
col.name as IndexColumn,
idx.name as IndexName,
idx.type_desc as IndexType,
count(*) over (partition by tb1.name,col.name) ColumnCount
from sys.indexes idx
join  sys.tables tb1       on idx.object_id=tb1.object_id
join sys.index_columns ic  on idx.object_id=ic.object_id and idx.index_id=ic.index_id 
join sys.columns col       on idx.object_id=col.object_id and ic.column_id=col.column_id
order by ColumnCount desc

------------------------------------------------------------------------------------------------------------
-----------------------------------   4. UPDATE STATISTICS

SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;
