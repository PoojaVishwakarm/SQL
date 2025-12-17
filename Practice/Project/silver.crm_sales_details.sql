select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details


--Check for Invalid Dates
select
nullif(sls_order_dt,0) as sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <=0
or len(sls_order_dt) !=8
or sls_order_dt >20500101
or sls_order_dt <19000101


--Check for Invalid date orders
select
*
from bronze.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt >sls_due_dt



-- Check Data Consistency : Between Sales Quantity and price
-->> Sales =Quantity *Price
-->> Values must not be null zero or negative

select distinct
sls_sales,
sls_quantity,
sls_price,
case when sls_sales is null or sls_sales <=0 or sls_sales !=sls_quantity * ABS(sls_price)
     then sls_quantity * ABS(sls_price)
     else sls_sales
end as  sls_sales,

case when sls_price is null or sls_price<=0
     then sls_sales / nullif(sls_quantity,0)
     else sls_price
end  as sls_price

from bronze.crm_sales_details
where sls_sales!=sls_quantity*sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
--==========================================================================================================
--=============================================================================================================================

IF OBJECT_ID('silver.crm_sales_details','U') is not null
drop table silver.crm_sales_details;
create table silver.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwn_create_date datetime2 default getdate()
)

insert  into silver.crm_sales_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
)

select
sls_ord_num,
sls_prd_key,
sls_cust_id,
case when sls_order_dt=0 or len(sls_order_dt) !=8 then null
     else CAST(CAST(sls_order_dt as varchar) as date)
end as sls_order_dt,

case when sls_ship_dt=0 or len(sls_ship_dt) !=8 then null
     else CAST(CAST(sls_ship_dt as varchar) as date)
end as sls_ship_dt,

case when sls_due_dt=0 or len(sls_due_dt) !=8 then null
     else CAST(CAST(sls_due_dt as varchar) as date)
end as sls_due_dt,

case when sls_sales is null or sls_sales <=0 or sls_sales !=sls_quantity * ABS(sls_price)
     then sls_quantity * ABS(sls_price)
     else sls_sales
end as  sls_sales,

sls_quantity,

case when sls_price is null or sls_price<=0
     then sls_sales / nullif(sls_quantity,0)
     else sls_price
end  as sls_price
from bronze.crm_sales_details



select * from silver.crm_sales_details
