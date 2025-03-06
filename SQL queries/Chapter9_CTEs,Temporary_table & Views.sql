use `e-commerce-sales-analysis-with-sql`;

-- Chapter9_CTEs,Temporary_table & Views

-- Commona Tables Expressions(CTEs)
/*
- It has temporary storage and exists only  during execurions.

- CTEs only be reused within the same query.

- CTEs have slightly faster for one-time use.



- Syntax:
      WITH cte_name AS (
	    SELECT....
        FROM.....
        GROUPBY....
        )
        
        SELECT ....
        FROM cte_name;
        
*/

with cte_orders as (
select 
customer_id,
order_date,
sum(total_amount) as total_sum_amount
from orders
group by customer_id,order_date
order by customer_id

)
select
customer_id,
(total_sum_amount/2) as half_sum_amount
from cte_orders
order by customer_id;


-- Temporary Table

/*
 -- Temporary Table exists for the session or transaction
 
 -- Its stores intermediate data for reuse
 
 -- It is better for large datasets needing multiple queries

-- Persists until session ends or manually dropped

-- Syntax
   
   CREATE TEMPORARY temp_table AS 
   SELECT....
   FROM.....
   GROUPBY...;
   
   SELECT * FROM temp_table;
*/

create temporary table temp_orders as
select 
customer_id,
order_date,
sum(total_amount) as total_sum_amount
from orders
group by customer_id,order_date
order by customer_id;

select 
customer_id,
min(total_sum_amount) as min_total_sum_amt
from temp_orders
group by customer_id
order by customer_id;


-- Views
/*
-- Permanent:stored in the database.

-- can be reused across multiple queries.

-- Slightly slower due to dynamic generation.

-- Ideal for reusable datasets and reporting

-- syntax
    CREATE VIEW view_table AS
    SELECT...
    FROM...
    GROPBY...;

    SELECT* FROM view_table;
*/

create view view_orders as
select 
customer_id,
order_date,
sum(total_amount) as total_sum_amount
from orders
group by customer_id,order_date
order by customer_id;

select 
customer_id,
max(total_sum_amount) as max_total_sum
from view_orders
group by customer_id
order by customer_id;
