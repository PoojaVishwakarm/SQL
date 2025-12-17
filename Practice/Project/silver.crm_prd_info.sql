select * from bronze.crm_prd_info

-- Check for nulls or duplicates in primary key
--Expectation : No Result
select
prd_id,
count(*)
from bronze.crm_prd_info
group by prd_id
having COUNT(*) >1 or prd_id is null

--------------------------------------------------------------------------------------------------------------------
--Check for invalid dates orders
select * 
from bronze.crm_prd_info
where prd_end_dt <
-----------------------------------------------------------------------------------------
--Check for null or negative numbers

select prd_cost
from bronze.crm_prd_info
where prd_cost<0 or prd_cost is null
----------------------------------------------------------------------------------------------------
-- Data Standardization & Consistency
select distinct prd_line
from bronze.crm_prd_info
-----------------------------------------------------------------------------------------------------
select
prd_id,
prd_key,
prd_nm,
prd_start_dt,
lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 as  prd_end_dt
from bronze.crm_prd_info





-----------------------------------------------------------------------------------------------------
-- DATA CLEANING

IF OBJECT_ID('silver.crm_prd_info','U') is not null
drop table silver.crm_prd_info;
create table silver.crm_prd_info(
prd_id   int,
cat_id  nvarchar(50),
prd_key  nvarchar(50),
prd_nm   nvarchar(50),
prd_cost  int,
prd_line  nvarchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date datetime2 default getdate()
);

insert into silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

select
prd_id,
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key)) as prd_key,
prd_nm,
isnull(prd_cost,0) as prd_cost,

case when upper(trim(prd_line)) ='M' then 'Mountain'
     when upper(trim(prd_line)) ='R' then 'Road'
     when UPPER(trim(prd_line)) ='S'  then 'other Sales'
     when UPPER(trim(prd_line)) ='T' then 'Touring'
     else 'n/a'
end prd_line,
cast(prd_start_dt as date) as prd_start_dt ,
CAST(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 AS DATE)  as  prd_end_dt
from bronze.crm_prd_info
