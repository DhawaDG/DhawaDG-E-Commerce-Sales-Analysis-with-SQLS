use `e-commerce-sales-analysis-with-sql`;

-- Chapter 4 SQL joins

/*
In this Chapter we will dicuss about
1) Primary key and Foreign Key
2) Types of Joins
   a) Inner Joins
   b) Left Joins
   c) Right Joins
*/
 
 -- 1 . Primary key and Foreign Key
 /*
 Primary Key
 
 -Primary key always contains unique data.
 
 -It cannot be null.
 
 -There must be a single primary key
 
 Foreign Key
 - The Foreign key is used to link  two tables.
 - A Foreign key in another table (child table) is used
   to point Primary key in another table (parent table)

 
 */
 
 -- since customers and orders table is imported datasets
 -- lets check if they consist primary key and foreign key
 
 show create table customers;
 
 show create table orders;
 
 -- they dont consist primary key and foreign key.
 -- lets add primary and foreign key using alter keyword
 
 -- for customers table
 
 alter table customers
 add primary key (customer_id);
 
 
-- for orders table 


alter table  orders 
-- ADD CONSTRAINT fk_customer  is good practice to name constraints so they can be easily referenced later.
-- If we don’t name it, MySQL will assign a system-generated name
add constraint fk_customer 
foreign key (customer_id) 
references customers(customer_id) 
-- on delete cascade helps in  if a row in the customers table is deleted, all related rows in the orders 
-- table will also be automatically deleted.
on delete cascade;

-- 1.query 1 Displaying two tables of their all columns in same table

select *
from customers c
inner join orders o 
on c.customer_id = o.customer_id
limit 20;

-- 1.query 2 Displaying only selected columns of two tables and conditions on same table

select  
c.customer_id,
c.name,
c.age,
c.gender,
c.city,
o.total_amount,
o.payment_method,
c.signup_date,
o.order_date
from customers c 
left join orders o
on c.customer_id = o.customer_id
where c.age between 20 and 40 
and o.total_amount > 200
order by c.age;

/*
-- Alias
as we can see we have customers c and orders o. here 'c' and 'o'
are alias of customers and orders respectively.
- The alies stores the tables values only during executions. Its like
  giving a short meaningfull name so we can use it easily later in the query.
  
- There is two use of alias : 
        1) When we use same table twice or more
		2) Using alies makes it clear which instance of the table
           table each column refers to called disambiquaty columns
-without alias ,SQl wouldnt know whethers we are refering to to the 
customers's row or the orders's row.

-- left_join , on , condition(c.customer_id = o.customer_id) we will discuss in coming 
  joins topic.
*/

-- 2) Types of Joins

-- a) Inner Joins
 /*
 - The inner join selects records that have matching values
   in both tables
 - we use inner joins when we want all records from matching values
   in both tables
 - for simpler , we can reference of high school maths in chapter of sets theory
   there we know Intersection of the sets A and B , denoted A ∩ B , 
   is the set of all objects that are members of both A and B.
 */
 

select  
c.customer_id,
c.name,
c.age,
c.gender,
c.city,
o.total_amount,
o.payment_method,
c.signup_date,
o.order_date
from customers c 
inner join orders o
on c.customer_id = o.customer_id
where c.age between 20 and 40 
and o.total_amount > 100 
and payment_method != 'PayPal'
order by c.age;
 
 
 -- b) Left joins
 
 /*
 -- the left joins returns all records from the left table, and
    the matched records from the right table.
 -- if there's no match in the right table , the result will 
    still include the row from the left table, but with null 
    values for columns  from right table.alter
 -- for simpler, as we disscuss earlier in Set theory reference it of 
    complement of B set in A set or simply A(Right table) minus B(left table).
 
 */
 
 select  
c.customer_id,
c.name,
c.age,
c.gender,
c.city,
o.total_amount,
o.payment_method,
c.signup_date,
o.order_date
from customers c 
left join orders o
on c.customer_id = o.customer_id
where c.age between 20 and 40 
and o.total_amount > 100 
and payment_method != 'PayPal'
order by c.age;
 
-- c) Right Joins

/*
-- the joins returns all records all recods from the right table
   ,and the matched records from the left table 
   
--if there's no match in the left table , the result will still
  include the row from the right table , but with NUll values 
  for columns from the left table.

-- For simpler, think of Set theory B(left table) minus A(Right table)

*/
 
 select  
c.customer_id,
c.name,
c.age,
c.gender,
c.city,
o.total_amount,
o.payment_method,
c.signup_date,
o.order_date
from customers c 
right join orders o
on c.customer_id = o.customer_id
where c.age between 20 and 40 
and o.total_amount > 100 
and payment_method != 'PayPal'
order by c.age;
 
 -- On Clause ensure onlys rows meeting the condition are joined in result table
 
  
 
 