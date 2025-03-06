use `e-commerce-sales-analysis-with-sql`;

-- Chapter 8 DATE and TIME functions

-- Datetime filds
/*
Datetime fields store both date and time in a single column.

They are useful for calculations like time differences or filtering
based on specific date and time ranges.

*/

-- STR_TO_DATE functions
/*
Convert a string into a datetime value

Require a formal string to interpret the input string correctly

Example Format: '%Y-%M-%D-%H:%I%P' for YYYY-MM-DD HH:MM AM/PM

*/

-- CONCAT functions
/*
 Use CONCAT to merge date and time strings

Use STR_TO_DATE to convert the concatenated string into a datetime value
*/

-- Since there is no column of time so we add signup_time column in table customers

-- lets add new columns signup_date 

alter table customers
add column signup_time varchar(50);

-- lets auto populate time in column signup_time

SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET signup_time = CONCAT(
    LPAD(
        CASE 
            WHEN FLOOR(RAND() * 12) + 1 = 12 THEN 12 
            ELSE FLOOR(RAND() * 12) + 1
        END,  
        2, '0'
    ), ':',
    LPAD(FLOOR(RAND() * 60), 2, '0'), ':',
    LPAD(FLOOR(RAND() * 60), 2, '0'), ' ',
    CASE WHEN RAND() < 0.5 THEN 'AM' ELSE 'PM' END
);

SET SQL_SAFE_UPDATES = 1;

-- lets confirms 
select * from customers;

-- still get null value on sign_up columm

SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET signup_time = CONCAT(
    LPAD(
        CASE 
            WHEN FLOOR(RAND() * 12) + 1 = 12 THEN 12 
            ELSE FLOOR(RAND() * 12) + 1
        END,  
        2, '0'
    ), ':',
    LPAD(FLOOR(RAND() * 60), 2, '0'), ':',
    LPAD(FLOOR(RAND() * 60), 2, '0'), ' ',
    CASE WHEN RAND() < 0.5 THEN 'AM' ELSE 'PM' END
     );

SET SQL_SAFE_UPDATES = 1;
  
-- lets again confirm 
select * from customers;

## Since there  we cant populate data , I decided to drop this idea

/*
here i have accidently deleted  signup_date instead i was 
going to delete the sigm_time where i try to populate time data.
lets try  restore the signup_date.

*/

alter table customers
drop column signup_date;

select * from customers;

-- Using rollback 
rollback;

-- data is not restore
select * from customers;

-- lets create table so we can discuss the topic of DATE functions properly

-- STR_TO_DATE and CONCAT

-- lets try comcate and convert varchar into date using STR_TO_DATE()
-- create table

create table market_date_info(
 market_date date,
 market_start_time varchar(20),
 market_end_time varchar(20)
 
);
-- inserting data
insert market_date_info(market_date,market_start_time,market_end_time)
values
('2023-10-01','08:00 AM','02:00 PM'),
('2023-10-02','09:00 AM','03:00 PM'),
('2023-10-03','10:00 AM','04:00 PM');


select
market_date,
market_start_time,
market_end_time,
str_to_date(concat(market_date,' ', market_start_time), 
			'%Y-%m-%d %h:%i %p') as start_date_time,
str_to_date(concat(market_date,' ', market_end_time), 
			'%Y-%m-%d %h:%i %p') as End_date_time
from market_date_info;
            
-- 1) STR_TO_DATE and CONCAT

-- use retrieve date part

-- creating view table 
create view vw_market_date_info as 

select
market_date,
market_start_time,
market_end_time,
str_to_date(concat(market_date,' ', market_start_time), 
			'%Y-%m-%d %h:%i %p') as start_date_time,
str_to_date(concat(market_date,' ', market_end_time), 
			'%Y-%m-%d %h:%i %p') as End_date_time
from market_date_info;




-- 2) retrieving date part by using EXTRACT()

select
start_date_time,
extract( year from start_date_time) as mkt_start_year,
extract(month from start_date_time) as mkt_start_month,
extract(day from start_date_time) as mkt_start_day,
extract(hour from start_date_time) as mkt_start_hr,
extract(minute from start_date_time) as mkt_start_min
from vw_market_date_info;


-- 3) Use DATE and TIME to extract Date and time

select
End_date_time,
date(End_date_time) as mkt_end_date,
time(End_date_time) as mkt_end_time
from vw_market_date_info;


--  4) DATE_ADD and DATE_SUB

select
start_date_time,
date_add(start_date_time,interval  2 year) as added_2yr,
date_add(start_date_time,interval 1 month) as added_1mnth,
date_add(start_date_time,interval 5 day) as added_5days,
date_add(start_date_time,interval 7 hour) as added_7hrs,
date_add(start_date_time,interval 6 minute) as added_6min
from vw_market_date_info;

select
start_date_time,
date_sub(start_date_time,interval  2 year) as minus_2yr,
date_sub(start_date_time,interval 1 month) as minus_1mnth,
date_sub(start_date_time,interval 5 day) as minus_5days,
date_sub(start_date_time,interval 7 hour) as minus_7hrs,
date_sub(start_date_time,interval 6 minute) as minus_6min
from vw_market_date_info;
  

-- 4.1) add multiple intervals  in a single call. 
select
start_date_time,
start_date_time+interval '2-1' year_month+interval '5 7:6'day_minute as add_datetime
from vw_market_date_info;

-- 4.2) sub multiple intervals  in a single call.
select
start_date_time,
start_date_time-interval '2-1' year_month-interval '5 7:6'day_minute as sub_datetime
from vw_market_date_info;


-- 5) DATEDIFF 

/*
-calculate the difference between two dates or datetimes values.

- Returns the differnce in days.alter

- Syntax: DATEDIFF(end_date,start_date)

*/
-- create view table 
create view vw_start_end_date_time as 
select
start_date_time,
start_date_time+interval '2-1' year_month+interval '5 7:6'day_minute as add_datetime
from vw_market_date_info;


select*from vw_start_end_date_time;

-- 5) finding date difference using DATEDIFF() and Subquery

select 
x.first_market,
x.last_market,
datediff(x.last_market,x.first_market) as days_first_to_last
from(
  select 
      min(start_date_time) as first_market,
      max(add_datetime) as last_market
      from vw_start_end_date_time
	) x;

-- DIFFDATE using traditional apporch
select
min(start_date_time) as first_market,
max(add_datetime) as last_market,
datediff(max(add_datetime),min(start_date_time)) as  days_first_to_last
from vw_start_end_date_time;


-- 5.1) Using CURDATE() to find differnce with current date

select
min(start_date_time) as first_market,
now() as `current_date`,
datediff(curdate(),min(start_date_time)) as  days_first_to_last
from vw_start_end_date_time;

-- 6) TIMESTAMDIFF()

/*
-calculate the difference between two datetime valus in 
 a specified interval(e.g. seconds, minutes,hours,days,months,years)
-syntax
 TIMESTAMDIFF(UNIT,start_datetime,end_datetime)
 
*/

select
min(start_date_time) as first_market,
now() as `current_date`,
timestampdiff(year,min(start_date_time),curdate()) as  year_diff,
timestampdiff(month,min(start_date_time),curdate()) as  month_diff,
timestampdiff(day,min(start_date_time),curdate()) as  day_diff,
timestampdiff(hour,min(start_date_time),curdate()) as  hr_diff,
timestampdiff(minute,min(start_date_time),curdate()) as  min_diff
from vw_start_end_date_time;
