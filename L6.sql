-- Active: 1787069770352@@localhost@3306@sakila
--================================================================================
--20 INTERVIEW-STYLE PRACTICE QUESTIONS
--MySQL + Sakila Sample Database
--Mix of Intermediate + Advanced
--Topics: Filtering • Joins • Subqueries • Sets • Grouping • Aggregates
--        Conditional Logic • Data Generation • Manipulation • Conversion
--        Views • Transactions
--(Questions only – no solution hints)
--================================================================================

USE sakila;

-- 1. Create a view named customer_spending that shows customer_id, full name,
--    total amount paid, and number of payments. Then query the view to return
--    only those customers whose average payment amount is higher than the
--    overall average payment amount across all customers.

create view customer_spending1 as
select
cu.customer_id,
concat(cu.first_name,' ',cu.last_name) as full_name,
sum(pay.amount) as total_amount,
count(pay.payment_id) as num_payments
from customer cu left join payment pay
on pay.customer_id=cu.customer_id
group by cu.customer_id ;

select cs.customer_id,cs.full_name
from customer_spending1 cs
where cs.total_amount / cs.num_payments>(
        select avg(amount) from payment
);

-- 2. Write a transaction that raises the rental_rate of every film in the
--    “Comedy” category by $0.50, but only if the new rate does not exceed
--    $4.99. If any film would exceed that limit, the entire transaction must
--    be rolled back. Afterward, report how many films were actually updated.

-- 3. Generate a complete list of every calendar day in July 2005 together with
--    the number of rentals that occurred on that day. Days with zero rentals
--    must still appear.

with recursive july_month as (

    select date('2005-07-01') as rent_day

    union all

    select date_add(rent_day, interval 1 day)
    from july_month
    where rent_day < '2005-07-31'

)

select
    jm.rent_day,
    count(re.rental_id) as number_of_rentals

from july_month jm

left join rental re
    on date(re.rental_date) = jm.rent_day

group by jm.rent_day

order by jm.rent_day;


-- 4. For each rating, display the rating, the number of films, the average
--    length (rounded to one decimal), and a label that reads “Long Form” if
--    the average length is greater than 120 minutes, otherwise “Standard”.

-- 5. Rank customers within each store by total amount paid (highest first).
--    Return store_id, customer full name, total paid, and the rank position
--    inside that store. Show only the top 5 customers per store.

-- 6. Find every pair of actors who have co-starred in at least four films.
--    Display both actors’ full names and the number of shared films.
--    Do not list the same pair twice.

-- 7. Transform the special_features column into a normalized result set that
--    contains one row for each individual feature of each film. Show film
--    title and the single special feature.

-- 8. Produce a single result set that contains:
--      • titles of films that have never been rented, labeled “Unrented Film”
--      • full names of customers who have never rented anything, labeled
--        “Inactive Customer”.

-- 9. For every film, show its title, the total number of inventory copies
--    across all stores, and a stock status:
--      “Out of Stock” when count = 0,
--      “Low Stock” when count is between 1 and 4,
--      “In Stock” when count is 5 or more.

-- 10. List every customer who has rented films from more categories than the
--     average number of distinct categories rented by all customers. Show
--     customer full name and the number of distinct categories they have
--     rented from.

-- 11. Create a view called monthly_revenue that aggregates total payment
--     amount by year and month. Then write a query against the view that
--     returns only those months whose revenue is higher than the previous
--     month’s revenue.

-- 12. Inside a single transaction, insert a new rental for customer_id 10
--     of an available copy of “ACADEMY DINOSAUR” from store 1, and
--     simultaneously insert the corresponding payment of $2.99. Ensure that
--     both inserts succeed or both are rolled back.

-- 13. Convert every film’s length into hours and remaining minutes
--     (e.g., 125 minutes → 2 hours 5 minutes). Display title, original
--     length, and the formatted duration string.

-- 14. Find all films whose replacement_cost is higher than the average
--     replacement_cost of films that share the same rating. Show title,
--     rating, and replacement_cost.

-- 15. Generate the next 6 month-start dates starting from the first day of
--     the current month. Display each date and a sequential period number
--     from 1 to 6.

-- 16. List every staff member together with the total revenue they collected
--     and a performance flag: “Top Performer” if their revenue is above the
--     average staff revenue, otherwise “Average”.

-- 17. Return the distinct set of customer IDs who have rented both an
--     “Action” film and a “Foreign” film, using set operations.

-- 18. For each category, show the category name and a comma-separated list
--     of the three longest film titles belonging to that category
--     (ordered by length descending).

-- 19. Write a query that returns, for every year present in the payment
--     table, the total revenue and the cumulative revenue from the earliest
--     year up to that year.

-- 20. Create a view named film_availability that shows film_id, title, and
--     the number of currently available copies (inventory items not present
--     in any open rental). Then query the view to list only those films
--     that have zero available copies.