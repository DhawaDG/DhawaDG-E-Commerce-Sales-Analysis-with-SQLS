use `e-commerce-sales-analysis-with-sql`;

-- Chapter 3  CASE Statement 

/*
The CASE statement is used to perform conditioanal logic in SQL.
*/
-- 1 Example
select 
order_id,
customer_id,
order_date,
total_amount,
case
when total_amount > 400 then 'Expensive'
when total_amount between 200 and 399 then'affordable'
when total_amount between 100 and 199 then 'Cheap'
else 'so cheap'
end as price_category

 from orders
 order by order_id desc
 limit 20;
 
 
 
 
-- 2 Grouping or Bining Continuos values Using CASE

/*
Binning is the process of grouping continuous values
(e.g. prices,ages,quantities) into discrete categories or 'bins'
Binning is uses for Sales segmentation(low,Medium,High),Temperatur Anlaysis(cold,warm,hot)
*/

-- Query1- Price category
select 
order_id,
customer_id,
order_date,
total_amount,
case
when total_amount > 400 then 'Expensive'
when total_amount between 200 and 399 then'affordable'
when total_amount between 100 and 199 then 'Cheap'
else 'so cheap'
end as price_category

 from orders
 order by order_id desc
 limit 20;
 
-- 3 Categorical Encoding using Case

/* 
There are two types of Categoriacal Encoding Using CASE:
a) Rank- Order Encoding
b) One-Hot Encoding 

a) Rank-Order Encoding
- convert categorical string variable into numeric values
  that represent a rank order
- Example Converting gender of customer from customers table 
  into Female=1 and Male=2
 
 */
 
 select 
 customer_id,
 name,
 age,
 case
 when gender ='Female' then 1
 when gender='Male' then 2
 end as gender_rank,
 city
 from 
 customers
 limit 20;
 
 
 /* b) One-Hot-Encoding
 - create binary columns (0 or 1) for each category.
 - Each column represents a category and a value of 1
   indicates that the row belongs  to that category
 - Example In order table , for Payment_method column like 
   paypal, debit card and credit card into are encoded separately
   encoded
 */
 select* from orders;
 
 select 
 customer_id,
 payment_method,
 case
 when payment_method = 'Credit Card' then 1 else 0 end as encode_credit_card,
 
 case
 when payment_method ='PayPal' then 1 else 0 end as encode_paypal,
 
 case
 when payment_method='Debit Card' then 1 else 0 end as encode_debit_card
 
 from orders
 order by customer_id
 limit 10;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 