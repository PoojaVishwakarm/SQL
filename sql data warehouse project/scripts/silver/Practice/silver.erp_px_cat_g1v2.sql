select * from bronze.erp_px_cat_g1v2

select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2

select distinct id from bronze.erp_px_cat_g1v2

select distinct cat  from bronze.erp_px_cat_g1v2

select distinct subcat from bronze.erp_px_cat_g1v2

select distinct maintenance from bronze.erp_px_cat_g1v2


--Check for unwanted spaces

select * from bronze.erp_px_cat_g1v2
where cat !=TRIM(cat) 
or subcat !=TRIM(subcat)
or maintenance !=TRIM(maintenance)

insert into silver.erp_px_cat_g1v2
(id,cat,subcat,maintenance)
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2