select * from bronze.crm_cust_info

-- Check for nulls or duplicates in primary key
--Expectation : No Result
select
cst_id,
count(*)
from silver.crm_cust_info
group by cst_id
having COUNT(*) >1 or cst_id is null

--------------------------------------------------------------------------------------------------------------------


--Check for unwanted Spaces
select cst_firstname
from silver.crm_cust_info
where cst_firstname !=TRIM(cst_firstname)

select cst_lastname
from silver.crm_cust_info
where cst_lastname !=TRIM(cst_lastname)

-----------------------------------------------------------------------------------------
select
cst_key
from silver.crm_cust_info
where cst_key !=TRIM(cst_key)
----------------------------------------------------------------------------------------------------
-- Data Standardization & Consistency
select distinct cst_gndr
from silver.crm_cust_info
 

 select distinct cst_marital_status
from silver.crm_cust_info
 

-----------------------------------------------------------------------------------------
-- data cleaning
insert into silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
select
cst_id,
cst_key,
TRIM(cst_firstname) as FisrtName,
TRIM(cst_lastname) as LastName,

case when upper(trim(cst_marital_status))='S' then 'Single'
     when upper(trim(cst_marital_status))='M' then 'Married'
     else 'n/a'
end cst_marital_status,


case when upper(trim(cst_gndr))='F' then 'Female'
     when upper(trim(cst_gndr))='M' then 'Male'
     else 'n/a'
end cst_gndr,
cst_create_date

from
(
select 
*, 
ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last  
from bronze.crm_cust_info
where cst_id is not null
)t where flag_last=1