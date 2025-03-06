use `e-commerce-sales-analysis-with-sql`;

 -- Chapter 6 Subquery
 
 /*
 Subquery is simply an sql query which is placed inside another
 sql query.
 -They can appear in the WHERE,FROM,or SELECT clauses and are 
  commonly used for filtering, comparisons,or data transformations.
 -- Advantages
  - We can execute this inner query on its own and it has no
    no dependency on any other query.
 - Outer query is basically using the inner query to filter
  the records and fetch the final results.
 */
  
-- Example

 -- 1 Find the sum of average total amount using subquery
 
    #traditional approach
	select avg(total_amount) from orders ;  -- 257.2891
    
    select *  from orders
    where total_amount>257.2891
    limit 10;
    
   #Approach Using Subquery 
   
   select *
   from orders
   where total_amount> (
   select avg(total_amount) 
   from orders)
   limit 10;
   
   
   -- 2 Different types of Sub query
    -- 2.1) Scalar Subquery
    -- 2.2) Multiple Row Subquery
    -- 2.3) Correlated Subquery
    
    -- 2.1) Scalar Subquery
    -- It always return 1 row and 1 column.
    
    -- 2.1.a) Scalar Subquery in Select Clause
    
    select 
    c.customer_id,
    c.name,
    (select sum(o.total_amount)
    from orders o
    where o.customer_id=c.customer_id) as total_spent
    from customers c
    limit 20;
   
   -- 2.1.b) Scalar query in WHERE Clause
   
    select *
   from orders
   where total_amount> (
   select avg(total_amount) 
   from orders)
   limit 10;
   
--  2.1.c) Scalar Subquery in HAVING Clause
  select 
  c.city,
  sum(o.total_amount) as total_spent
  from customers c
  left join orders o 
  on c.customer_id = o.customer_id
  group by c.city
  having sum(o.total_amount) > (select avg(total_amount) from orders);
  
 -- 2.1.d) Scalar Subquery with CASE Statement
select 
c.customer_id,
c.name,
(select sum(o.total_amount) from orders o where o.customer_id=c.customer_id) as total_spent,
case
when (select sum(o.total_amount) from orders o where o.customer_id=c.customer_id) > 400 then 'MAX spent'
when (select sum(o.total_amount) from orders o where o.customer_id=c.customer_id) between 200 and 399 then 'Medium spent'
when (select sum(o.total_amount) from orders o where o.customer_id=c.customer_id)  < 199 then 'Min spent'
end as spent_category
from customers c
limit 20;

 -- 2.2) Multiple-Row Subquery in SQL
 
 -- it returns multiple rows and columns.
 
 -- IN,ANY,ALL and EXISTS operators are used 
 
 -- 2.2.a) Using In 
 /*
 -The subquery returns a list of customer_ids from the orders table.
 -The outer query selects customers whose customer_id is in this list.
*/
 
 select 
 customer_id,
 name
 from customers
 where customer_id in (
 select distinct customer_id
 from orders)
 limit 20;
 
 -- 2.2.b) Using ANY
   /*
   The ANY operator compares the total spending of each customer (from the outer query) 
   to the list of total spending values returned by the subquery. Only accept if its greater
   than outer query which value is atleast greater with one value of subquery
   total spending values
   */
 select 
 c.customer_id,
 c.name,
 sum(o.total_amount) as total_spending
 from customers c
 join orders o 
 on c.customer_id=o.customer_id
 group by c.customer_id,c.name
 having sum(o.total_amount) > any (
 select sum(o2.total_amount)
 from customers c2
 join orders o2 
 on c2.customer_id=o2.customer_id
 group by c2.customer_id
 );
 
-- 2.2.c) Using ALL 
/*
The ALL operator compares the total spending of each customer (from the outer query) 
to the list of total spending values returned by the subquery.Only accept if its greater
than outer query which value is greater than all value of total spending of subquery.
*/


  select 
 c.customer_id,
 c.name,
 sum(o.total_amount) as total_spending
 from customers c
 join orders o 
 on c.customer_id=o.customer_id
 group by c.customer_id,c.name
 having sum(o.total_amount) > all (
 select sum(o2.total_amount)
 from customers c2
 join orders o2 
 on c2.customer_id=o2.customer_id
 group by c2.customer_id
 );
 
-- 2.2.d) Using Exists
 -- EXISTS checks if a subquery returns any rows.
 -- We use Use EXISTS when you only need to check for the existence of data, not the actual values
 select c.customer_id,c.name
 from customers c
 where exists (
     select 1
     from orders o
     where o.customer_id= c.customer_id
     
     );
 
 -- 2.2.e) Using in the FROM clause
 
	select
    customer_id,
    avg(total_sum) as avg_total_sum
    from(
         select 
         customer_id,
         sum(total_amount) as total_sum
         from orders
         group by customer_id) as  order_values
	group by customer_id
    limit 20;

-- 2.2.f) Using in the HAVING clause
  
  
select
customer_id,
sum(total_amount) as total_sales
from orders
group by customer_id
having sum(total_amount) > (
                            select
                            avg(total_amount)
                            from orders);



-- 2.3) Correlated Subquery
 
 -- A correlated subquery is a type of subquery in SQL where the inner query depends on the outer query for its execution. 

-- 2.3.a) Find all customer who have placed at leat one order
 
   select 
   customer_id,
   name
   from customers c
   where exists (
                  select 1
                  from orders o 
                  where o.customer_id=o.customer_id -- correlated conditions
                  )
   limit 20;

-- 2.3.b) Correlated Subquery with Aggregation
-- Find all customer whose total spending is greater than the average spending of all customer
select
customer_id,
total_spending
from(
     select
     c.customer_id,
     sum(o.total_amount) as total_spending
     from customers c
     join orders o
     on c.customer_id= o.customer_id
     group by customer_id )
     as customer_spending 
where total_spending > (
						 select avg(total_spending)
                         from(  select
								c2.customer_id,
                                sum(o2.total_amount) as total_spending
                                from customers c2 
                                join orders o2
                               on c2.customer_id=o2.customer_id
                               group by c2.customer_id )
						 as customer_spending2
                         )
group by customer_id;
                                
-- 2.3.c) Correlated Subquery with UPDATE and DELETE

-- UPDDATE Keyword that uses Correlated Subquery
  update orders o 
  set total_amount= 1.1 * total_amount
  where  total_amount < (
						 select avg(total_amount)
                         from orders o2
                         where o2.customer_id=o.customer_id
                         );
  
  /*
  This is example of only when we want to directly update the date 
  of original table means it changes data permanently. Since we want 
  data integrity for further query. Therefore , we are not excecuting 
  this above query.
  */
  
  delete from orders o 
  where not exists (
                    select 1
                    from orders o2
                    where o2.customer_id=o.customer_id
                    and o2.order_date >= now() - Interval '1 year'
                    );
  
-- same for delete not executing query


  
  
							
                            



    
 
 
 
 
 
 
 
 
 
 