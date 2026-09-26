/*================================================================================
5 ADVANCED INTERVIEW-STYLE PRACTICE QUESTIONS
MySQL + Sakila Sample Database
Focus: Advanced Analytics • Window Functions • Complex Logic
(Questions only – no solution hints)
================================================================================*/

USE sakila;

-- 1. For each customer, calculate their total spending and assign them a
--    lifetime value segment using NTILE(5). Then, within each segment, rank
--    the customers by the number of distinct films they have rented.
--    Display customer full name, total spent, segment number, distinct film
--    count, and the rank inside the segment.

with dist_films as (
    select distinct(ff.film_id) as distinct_films,
    cc.customer_id as customer_key
    from customer cc left join rental re
    on cc.customer_id=re.customer_id
    left join inventory inv
    on inv.inventory_id=re.inventory_id
    left join film ff
    on ff.film_id=inv.film_id
    group by ff.film_id
),
 cust_info as (
    select concat(cc.first_name,' ',cc.last_name) as full_name,
    sum(pay.amount) as total_spent,
    cc.customer_id as cust_key,
    ntile(5) over (partition by cc.customer_id order by sum(pay.amount)) as segment
    from customer cc left join payment pay
    on cc.customer_id=pay.customer_id
    group by cc.first_name,cc.last_name

)

select df.distinct_films,
ci.full_name,
ci.total_spent,
ci.segment,
rank() over (partition by ci.segment order by df.distinct_films) as ranking
from cust_info ci left join dist_films df
on ci.cust_key=df.customer_key;


-- 2. Identify every rental that is more than two standard deviations above
--    the average payment amount for that customer. Show customer full name,
--    payment amount, payment date, the customer’s average payment, and the
--    standard deviation of their payments.

-- 3. Build a month-over-month retention report for 2005: for each month show
--    the number of customers who rented in that month, the number who also
--    rented in the previous month, and the retention percentage.
--    Months with no prior activity should still appear.

-- 4. For every film, show its title, the total revenue it generated, and a
--    cumulative revenue percentage of the entire catalog when films are
--    ordered from highest to lowest revenue (i.e., a running contribution
--    to 100 %).

-- 5. Find the longest streak of consecutive days in which at least one
--    rental occurred in 2005. Return the start date of the streak, the end
--    date of the streak, and the length of the streak in days.