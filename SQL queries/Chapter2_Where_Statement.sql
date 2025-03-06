use `e-commerce-sales-analysis-with-sql`;

-- Chapter 2 The Where Clause
/*
The WHERE clause is used in SQL to filter records based on 
specified conditions. It allows you to extract only those 
rows that meet the criteria defined in the condition
*/
 -- 1 where clause Exampla
 select * from customers
 where gender='Female'
 limit 5;
 
 -- 2 using where clause on 'filtering on conditions'
 
 select * from customers
 where age between 20 and 30 
 or age between 50 and 60
 limit 5;
 

 
 -- 3. using In keyword
 
select * from orders
where payment_method in ('PayPal','Debit Card')
order by customer_id
limit 10;
 
 -- 4 using Like keyword
 
 select * from customers
 where name like 'Christ%'
 order by name
 limit 20;
 
 -- 5 using Is Null keyword
  select * from customers
  where age is Null;
  
  -- since we dont have null value in age which returns empty column
  
  -- 6 Using and, equal and not equal operator
  
  select * from customers
  where  age=30 and gender != 'Male';
 
 