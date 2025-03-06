SELECT * FROM `e-commerce-sales-analysis-with-sql`.customers;

use `e-commerce-sales-analysis-with-sql`;

-- Chapter 1 Select Clause/Statement
/*
-This statement retrives all columns(*) from the specified tables.
 also combines data from multiple tables,filter the results,perform
 calulations.
 -lets discuss what we can perform with Select clause.alter
 */
 
 -- 1. Selecting whole table from table
 
     select * from customers
	 limit 5;
     
 -- 2. Selecting Individual column from table
 
     select
     
     customer_id,
     age,
     city
     
     from
     
     customers
     
     limit 5;
     
-- 3. Aliasing or Renaming column

   select 
   
   customer_id as name_id,
   age,
   city
   
   from
   
   customers
   
   limit 5;
     
     
  -- 4 For conditional based selecting column
  
  select  * from customers
  where age between 20 and 30
  limit 10;
     
  -- 5 for doing calculations 
  
  select
  customer_id,
  total_amount,
  sum(total_amount) as total_bill_of_customer
  
  from orders
  group by customer_id, total_amount
  limit 20;
     
     