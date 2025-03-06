use `e-commerce-sales-analysis-with-sql`;

-- Chapter 4 Aggregating Results for Analysis

/*
In this chapter we will discuss about different type of aggregate 
functions like count(),Max(),Min(),SUM() and AVG(). Also grouping 
data with 'Group By' and filtering group using 'Having'.
*/
  
 -- 1 Different type of aggregate fuctions.
 
 -- 1) Count() 
 
 select count(order_id) from orders;
 
 -- 2) Max() 
 select max(age) from customers;
 
 -- 3) Min()
 select min(total_amount) from orders;
 
 -- 4) SUM()
 select sum(total_amount) from orders;
 
 -- 5) AVG()
 
 select avg(total_amount) from orders;
 
 -- 6) Distinct Count()
 select count(distinct payment_method) from orders;

 
 -- 2 Grouping data with Group By
 
 /*
 -  Group By clause groups rows in your dataset based on 
    the values in one or more columns.
-  Its often used with aggregate functions(like SUM,COUNT, AVG)
   to calculate summary statistics for each group.
 */
 
 select 
 c.customer_id,
 c.name,
 o.total_amount,
 o.payment_method,
 Sum(o.total_amount) as total_bill_amount
 from customers c 
 left join orders o 
 on c.customer_id = o.customer_id
 where total_amount > 450
 group by c.customer_id,c.name,o.total_amount,o.payment_method
 order by c.customer_id;
 
 -- lets try  different data manipulation appoarch using Group By
 
 -- 2.1) total spending by Gender
 
     select
     c.gender,
	 sum(o.total_amount) as total_spending_by_gender
     from customers c
     left join orders o
     on c.customer_id=o.customer_id
     group by c.gender;
     
 --  2.2) total_Revenue_through_payment_vendor
    
    select
    payment_method,
    sum(total_amount) as total_revenue_through_payment_vendor
    
    from orders
    group by payment_method;
 
 
 -- 3  Filtering with Having
 
 /*
 The HAVING clause is used to filter data after aggregation
 It works with grouped data, applying conditions on the 
 aggregated values( e.g. SUM, COUNT,AVG)
 
 - It is differ from WHERE , which filter before aggregation
   on row data.
 
 - Shortly, it is used for filtering after grouping
 */
 
 select 
 c.customer_id,
 c.name,
 o.total_amount,
 o.payment_method,
 Sum(o.total_amount) as total_bill_amount
 from customers c 
 left join orders o 
 on c.customer_id = o.customer_id
 where total_amount > 450
 group by c.customer_id,c.name,o.total_amount,o.payment_method
 having total_bill_amount>450  # Having keyword
 order by c.customer_id;
 
 
 
 
 
 
 
 
 
 
 