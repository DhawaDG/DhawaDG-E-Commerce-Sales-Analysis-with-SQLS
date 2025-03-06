use `e-commerce-sales-analysis-with-sql`;

-- Chapter11_Building_SQL_Datasets_for_Analytical_Reporting
 /*
 In this chapter we'll discuss about requirements for Analytical
 Datasets.The core concept here is designing reusable analytical
 datasets that can be used to answer multiple questions and bulid various
 reports.
 This involves:
 1. Understanding Requrements:
   - Anticipating the type of question that might be asked and dimension(eg. time,vendor,product)
     and measures(e.g. sales,quantity) needed to answer them.alter
 2. Choosing Granularity:
  - Deciding the level of details(e.g. daily,weekly) at which the 
	 dataset should be summarized.
 3. Combining Data
   - Joining relevant tables to include all necessary fields(e.g. vendor_names
    ,market_days) for reporting.
 4. Summarizing data
   - Aggregating data (e.g. summing sales) to create a dataset
     that is easy to query and anlyze.
 */

 -- 1) Design the Reusable Dataset
 select
 c.customer_id,
coalesce(o.order_id,'No order') as order_id,
c.name,
c.city,
coalesce(o.order_date,'No order') as order_date,
coalesce(o.total_amount,'No order') as total_amount,
coalesce(o.payment_method,'No order') as payment_method,
coalesce(round(sum(o.total_amount),2),'No order') as total_purchases_by_customers
from
customers c 
left join orders o 
on c.customer_id=o.customer_id

group by 
c.customer_id,
o.order_id,
c.name,
c.city,
o.order_date,
o.total_amount,
o.payment_method

order by
c.customer_id,o.order_id;


-- 2)Use the Dataset for Analysis

-- 2.1) Total sales last week

select
round(sum(sales),3) as total_sales_last_week
from
( 
select 
o.order_date,
round(sum(total_amount),3) as sales
from orders o
where o.order_date between '2024-10-10' and '2024-10-17'
group by o.order_date) as weekly_sales;

-- 2.2) Total sales by payment method
select
payment_method,
round(sum(total_amount),3) as sales_by_payment_method
from  orders
group by payment_method;

-- 3) Using Custom Analytical Datasets in SQL: CTEs and Views

 -- 3.1) create resuable data using views
 
 create view vw_customer_orders1 as
select
 c.customer_id,
coalesce(o.order_id,'No order') as order_id,
c.name,
c.city,
coalesce(o.order_date,'No order') as order_date,
coalesce(o.total_amount,'No order') as total_amount,
coalesce(o.payment_method,'No order') as payment_method
from
customers c 
left join orders o 
on c.customer_id=o.customer_id

order by
c.customer_id,o.order_id;
 
 
 --  3.2) percentage of sales per payment_method
 
 -- usig subquery
 select
payment_method,
concat(round(sum(total_amount)*100.0/(select sum(total_amount) from vw_customer_orders1),2),'%') as percent_sales
from vw_customer_orders1
where total_amount> 0  -- avoiding null
group by payment_method
order by percent_sales desc;





 
 
 
 
 
 
 
 
 
 
 
 
 
 