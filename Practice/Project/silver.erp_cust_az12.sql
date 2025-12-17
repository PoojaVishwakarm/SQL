select 
cid,
bdate,
gen 
from bronze.erp_cust_az12

-- Identify out f range dates
select distinct
bdate
from bronze.erp_cust_az12
where bdate< '1924-01-01' or bdate >GETDATE()


--Data Standardization & Consistency
select distinct gen,
case when UPPER(trim(gen)) in ('F','FEMALE') then 'Female'
     when UPPER(trim(gen)) in ('M','MALE') then 'Male'
     else 'n/a'
end as gen
from bronze.erp_cust_az12
--=======================================================================================
--================================================================================================
insert into silver.erp_cust_az12(cid,bdate,gen)
select
case when cid like 'NAS%' then SUBSTRING(cid,4,LEN(cid))
     else cid
end as  cid,

case when bdate>GETDATE() then null
     else bdate
end as bdate,

case when UPPER(trim(gen)) in ('F','FEMALE') then 'Female'
     when UPPER(trim(gen)) in ('M','MALE') then 'Male'
     else 'n/a'
end as gen

from bronze.erp_cust_az12