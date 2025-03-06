use `e-commerce-sales-analysis-with-sql`;

-- Chapter10_ Exploratory_Date_Analysis(EDA)

-- 1)Exploring the orders table


select 
c.customer_id,
coalesce(o.order_id,'no order') as order_id, 
c.name,
count(o.order_id) as count_of_order
from customers c
left join orders o 
on o.customer_id=c.customer_id
group by c.customer_id,o.order_id,c.name
order by c.customer_id
limit 20;

-- 2)Exploring Possible Coluns Value

 -- 2.1) Preview the vendor_inventory table
    
select * from orders
limit 5;

 -- 2.2) Checks for Unique Combinations
select 
customer_id,
count(*)
from orders
group by customer_id
having count(*) >1;

 -- 2.3) Analyze Date Ranges
 select
 min(order_date) as min_order_date,
 max(order_date) as max_order_date
 from orders;
 
 -- 2.4) Analyse order activity
 
 select
 order_id,
 min(order_date) as frist_order_date,
 max(order_date) as last_order_date
 from orders
 group by order_id
 order by frist_order_date,last_order_date
 limit 10;
 
 -- 3)Exploring Changes over TIME
 
  -- 3.1) Analyze no. of order based on year and month
  
  select
  extract(year from order_date) as order_year,
  extract(month from order_date) as order_month,
  count(distinct order_id) as order_count
  from orders
  group by extract(year from order_date),
		   extract(month from order_date)
  order by extract(year from order_date),
		   extract(month from order_date);
           
  -- 3.2) Explore a specific customer id
  
 select
 o.customer_id,
 o.order_id,
 c.name,
 c.age,
 c.gender
 from orders o
 left join customers c
 on o.customer_id=c.customer_id
 where o.customer_id=77
 order by o.order_date;
 
 -- 3.3) Identify customer active no of month
 
 select 
 customer_id,
 count(distinct extract(month from order_date)) as active_no_of_month
 from orders
 group by customer_id
 order by active_no_of_month desc
 limit 20;
 
 -- 4) Detect active order by month of whole year
 
 with months as(
 select 1 as month
 union select 2 
 union select 3
 union select 4
 union select 5
 union select 6
 union select 7
 union select 8
 union select 9
 union select 10
 union select 11
 union select 12 
)
select 
m.month,
count(o.order_date) as active_month_count
from months m
left join orders o 
on m.month = Extract(month from o.order_date)
group by m.month
order by m.month;
