--================================================================================
--20 INTERMEDIATE-TO-ADVANCED PRACTICE QUESTIONS
--MySQL + Sakila Sample Database
--Topics: Filtering • Joins • Subqueries • Sets • Grouping • Aggregates
  --       Conditional Logic • Data Generation • Manipulation • Conversion
--(Questions only – no solution hints)
--================================================================================

USE sakila;

-- 1. For each rating, show the number of films, the average length (rounded
--    to 1 decimal place), and the total replacement cost. Only include
--    ratings that have more than 150 films.

select count(ff.film_id) as no_of_films,round(avg(ff.length),1) as avg_length,sum(ff.replacement_cost) as replacement_cost,ff.rating
from film ff
group by ff.rating
having count(*)>150;

-- 2. Create a single result set that lists all customer full names from
--    store 1 and all staff full names, clearly indicating whether each
--    person is a “Customer” or “Staff”.
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    'Customer' AS person_type
FROM customer
WHERE store_id = 1

UNION ALL

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    'Staff' AS person_type
FROM staff;


-- 3. List the film title and a custom label that reads “Short”, “Medium”,
--    or “Long” depending on whether the length is under 90 minutes,
--    between 90 and 120 minutes, or over 120 minutes.


select title, 
    (case 
    when length<=90 then 'Short'
     when  length>120 then 'Long'
     when length between 90 and 120 then 'Medium'
     else 0
     end 
    ) as labels
from film 
;
-- 4. Show the customer ID, full name, and a column called “status” that
--    displays “High Value” if the customer has spent more than $150,
--    “Medium Value” if they spent between $100 and $150, and “Low Value”
--    otherwise.

select cc.customer_id, concat(cc.first_name,' ',cc.last_name) as full_name,
case 
 when sum(pp.amount)>150 then 'High Value'
 when sum(pp.amount) between 100 and 150 then 'Medium Value'
 when sum(pp.amount) <150 then 'Low Value'
 else 0
 end as status
from customer cc inner join payment pp
on pp.customer_id=cc.customer_id
group by cc.customer_id,cc.first_name,cc.last_name;



-- 5. Generate a list of the next 12 months starting from the current date,
--    formatted as “YYYY-MM”, along with a sequential month number from 1 to 12.

with recursive year_day_calendar as (
    select 
    curdate() as month_date,
    1 as month_num
    union all
    select date_add(month_date,interval 1 month),month_num+1
    from year_day_calendar where month_num<12

)
SELECT
    DATE_FORMAT(month_date, '%Y-%m') AS month,
    month_num
FROM year_day_calendar;


-- 6. SELECT
    select title,
    rental_rate,
    ROUND(
        (rental_rate / (SELECT MAX(rental_rate) FROM film)) * 100,
        2
    ) AS rental_rate_percentage
FROM film;

-- 7. Find the top 5 busiest days of the week (by number of rentals) across
--    the entire rental history. Display the day name and the rental count.
select DAYNAME(rental_date) AS day_name,, count(rental_id) as rental_count
FROM rental
GROUP BY DAYOFWEEK(rental_date), DAYNAME(rental_date)
ORDER BY rental_count DESC
LIMIT 5;

-- 8. For each store, calculate the total revenue and express it as a
--    percentage of the company’s overall revenue. Show store ID, total
--    revenue, and the percentage (rounded to one decimal place).

select cu.store_id,sum(pp.amount) as total_revenue, round(SUM(pp.amount) * 100.0 /(SELECT SUM(amount) FROM payment),1) as revenue_perc
from customer cu inner join payment pp 
on cu.customer_id=pp.customer_id
group by cu.store_id;

-- 9. List every actor’s full name together with a comma-separated list of
--    the distinct categories of films they have appeared in.

select concat(ac.first_name,' ',ac.last_name) as full_name, group_concat(distinct cat.name order by cat.name SEPARATOR ', ') as category_list
from category cat inner join film_category fc
on fc.category_id=cat.category_id
inner join film_actor fa
on fa.film_id=fc.film_id
inner join actor ac
on ac.actor_id=fa.actor_id
group by ac.actor_id,ac.first_name,ac.last_name;


-- 10. Show the film title and a new column that contains the first 20
--     characters of the description followed by “...” if the description
--     is longer than 20 characters; otherwise show the full description.

select title, 
(
    case 
    when length(description)>20 then concat(left(description, 20),'...')
    when length(description)<20 then description
    else 0
    end
) as descr
from film;


-- 11. Retrieve the customer full name and the number of days between their
--     first rental and their most recent rental. Only include customers
--     who have made at least two rentals.

-- 12. Create a ranking of all films by rental rate within each category
--     (highest rate first). Display category name, film title, rental rate,
--     and the rank position inside that category.

-- 13. Find all payments that were made on the same date as the customer’s
--     very first payment. Show payment ID, customer full name, amount, and
--     payment date.

-- 14. List the titles of films that have a replacement cost higher than the
--     average replacement cost of films in the same rating group.

-- 15. Generate a report that shows, for each year and month in 2005, the
--     total number of rentals and the running total of rentals up to that
--     month.

-- 16. Display the staff full name and a column that shows “Manager” if the
--     staff member is the manager of a store, otherwise “Employee”.

-- 17. Convert the rental_date of every rental into three separate columns:
--     year, month name, and day of the month. Only include rentals from
--     August 2005.

-- 18. Find customers whose last name starts with the same letter as the
--     first letter of their city name. Show customer full name and city.

-- 19. Produce a list of all categories that have no films rated “NC-17”.
--     Display only the category name.

-- 20. For each customer, show their full name, total amount paid, and a
--     column that concatenates the word “Customer since” with the year
--     they were created (e.g., “Customer since 2006”).