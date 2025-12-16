select 
cid,
cntry
from bronze.erp_loc_a101

--Data Standardization & Consistency
select distinct cntry,
case when trim(cntry)='DE' then 'Germany'
     when trim(cntry) in ('US','USA') then 'United States'
     when trim(cntry) = '' or cntry is null then 'n/a'
     else TRIM(cntry)
end as cntry
from bronze.erp_loc_a101


insert into silver.erp_loc_a101
(
cid,
cntry
)

select 
replace(cid,'-','') cid,
case when trim(cntry)='DE' then 'Germany'
     when trim(cntry) in ('US','USA') then 'United States'
     when trim(cntry) = '' or cntry is null then 'n/a'
     else TRIM(cntry)
end as cntry
from bronze.erp_loc_a101


select * from silver.erp_loc_a101