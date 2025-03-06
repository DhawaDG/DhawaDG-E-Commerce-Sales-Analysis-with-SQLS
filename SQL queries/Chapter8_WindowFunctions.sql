use `e-commerce-sales-analysis-with-sql`;

-- Chapter 7 Window Functions

/*
The SQL windows functions Rank, Dense-Rank and Row-Number
are used to assigned rank values to rows within partitions
of a dataset. They are valuable in scenarios that require ranking
or ording records based on specific criteria.

There are different types of windows functions which we will
discuss further. They are:
1)RANK() Window Function
2)DENSE_RANK() Window Function
3)ROW_NUMBER() Window Function
4)NITLE(n) Window Function
5)Aggregate Window Function
6) LAG()  and LEAD() Window Function
*/
  
-- 1) RANK() Window Function
/*
-- Assigns the same rank to rows with the same value but skips
   rank for ties
-- If multiple rows have the same value, they get the same but the 
   next rank is skipped
-- Example, Think of it like a school competition where two students
  tie for 1st place, so the next student gets 3rd place.
*/
  -- 1.1)
select
customer_id,
name,
age,
city,
rank() over (partition by age order by customer_id )  age_rank
from customers
order by age 
limit 30;

--  1.2)
select
customer_id,
payment_method,
total_amount,
rank() over (partition by customer_id order by total_amount) as  individual_customer_spending_rank
from orders
order by customer_id
limit 30;
                            

-- 2) Dense_Rank
/*
-- Like Rank, but without skippers numbers.

-- Example, If two student tie for 1st place,
   the next student gets 2nd place
*/
--  2.1 )
 select
customer_id,
name,
age,
city,
dense_rank()  over (partition by age order by customer_id )  age_rank
from customers
order by age 
limit 30;
--  2.2 ) 
select
customer_id,
payment_method,
total_amount,
dense_rank() over (partition by customer_id order by total_amount) as  individual_customer_spending_rank
from orders
order by customer_id
limit 30;
 
 -- 3) Row_Number
 /*
 -- Every row gets a unique number even if the values are identical.
    NO ties allowed like assigning seat numbers in a theater.
 */
 -- 3.1 )
 select
customer_id,
name,
age,
city,
row_number() over (partition by age order by customer_id )  age_rank
from customers
order by age 
limit 30;
-- 3.2 )
select
customer_id,
payment_method,
total_amount,
row_number() over (partition by customer_id order by total_amount) as  individual_customer_spending_rank
from orders
order by customer_id
limit 30;
 
 -- 4) NITLE 
 /*
 The NTILE function divides rows into a specified number of groups(n)
 and assigns a group number to each row.
 
 It is useful for spiltting data into equal(or nearly equal)
 bucket or percentiles.
 
 NTLE assigns row numbered based purely on count, not the actual
 field values.
 */
 
 -- 4.1) without partition by
select
customer_id,
payment_method,
total_amount,
ntile(4) over(order by total_amount desc) as bucket_spent_rank
from orders
limit 16;
-- 4.2) with partition by
select
customer_id,
payment_method,
total_amount,
ntile(4) over(partition by customer_id order by total_amount desc) as bucket_spent_rank
from orders 
order by customer_id 
limit 16;

-- 5) Aggregate Window Functions

--  5.1)using SUM() as a window 

select
customer_id,
order_date,
order_id,
payment_method,
total_amount,
sum(total_amount) over (partition by customer_id order by total_amount) as sum_rank
from orders
order by customer_id
limit 20;
               
-- 5.2)using AVG() as a window

select
customer_id,
order_date,
order_id,
payment_method,
total_amount,
avg(total_amount) over (partition by customer_id order by total_amount) as avg_rank
from orders
order by customer_id
limit 20;

-- 5.3)using Coubt() as a window 

select
customer_id,
order_date,
order_id,
payment_method,
total_amount,
count(total_amount) over (partition by customer_id order by total_amount) as count_rank
from orders
order by customer_id
limit 20;

-- 6) LAG and LEAD

-- 6.1) Lead() functions
/*
- Retrieves the values from a subsequent or next row in the dataset

-syntax
LEAD(column_name, offset, default_value) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
   )

*/

select
customer_id,
order_date,
order_id,
payment_method,
total_amount,
lead( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) as next_order_amount
from orders
order by customer_id,order_date
limit 30;

-- 6.2) LAG() functions

/*
-- Retrieves the value from a previous row in the dataset
-- syntax
   LEAD(column_name, offset, default_value) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
   )
*/

select
customer_id,
order_date,
order_id,
payment_method,
total_amount,
lag( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) as previous_order_amount
from orders
order by customer_id,order_date
limit 30;
               
-- 6.3) Difference between the current and next order amount


  select 
customer_id,
order_id,
total_amount,
lead( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) as next_order_amount,

lead( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) - total_amount as difference
from orders
order by customer_id,order_date
limit 30;
  
-- 6.4)Difference between the current and previous order amount

select 
customer_id,
order_id,
total_amount,
lag( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) as previous_order_amount,
total_amount- lag( total_amount,1,0) over(
					partition by customer_id
                    order by order_date) as difference
from orders
order by customer_id,order_date
limit 30;
  
  
  
  