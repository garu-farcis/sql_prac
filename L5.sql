-- Active: 1787069770352@@localhost@3306@sakila
--================================================================================
--10 INTERVIEW-STYLE PRACTICE QUESTIONS
--MySQL + Sakila Sample Database
--Mix of Intermediate + Advanced
--Topics: Filtering • Joins • Subqueries • Sets • Grouping • Aggregates
--        Conditional Logic • Data Generation • Manipulation • Conversion
 --       Views • Transactions
--(Questions only – no solution hints)
--================================================================================

USE sakila;

-- 1. Create a view that shows, for every customer, their full name, total
--    amount paid, number of rentals, and a loyalty tier (“Gold” if total
--    spent > $200, “Silver” if between $100 and $200, “Bronze” otherwise).
--    Then write a query that uses this view to list only Gold-tier customers
--    who have more than 40 rentals.

create view temp_view1  
as select concat(cu.first_name,' ',cu.last_name) as full_name,
 sum(pay.amount) as total_amount,
    COUNT(DISTINCT pay.rental_id) AS number_of_rentals,
     (
        case 
        when sum(pay.amount)>200 then 'Gold'
        when sum(pay.amount) between 100 and 200 then 'Silver'
        else 'Bronze'
        end
 ) as loyalty_tier
 from customer cu inner join payment pay
 on pay.customer_id=cu.customer_id
group by cu.customer_id,cu.first_name,cu.last_name;
select * from temp_view1 where loyalty_tier = 'Gold'
  AND number_of_rentals > 40; 




-- 2. Write a transaction that transfers $10 from customer_id 1’s most recent
--    payment to customer_id 2 by inserting an adjustment payment record for
--    each customer (one negative, one positive) and ensures both operations
--    succeed or both are rolled back. Include proper error handling.



-- 3. Generate a report that lists every day in August 2005 together with the
--    number of rentals that occurred on that day. Days with zero rentals
--    must still appear in the result.


with recursive august_days as (
        select date('2005-08-01') as rent_day
        union all
        select date_add(rent_day,interval 1 day)
        from august_days
        where rent_day<'2005-08-31'
)
select ad.rent_day,
count(r.rental_id) as rental_id
from august_days ad left join rental r
on date(r.rental_date)=ad.rent_day
group by ad.rent_day
order by ad.rent_day;


-- 4. For each film category, show the category name, the number of films,
--    the average rental rate, and a column that displays “Premium” if the
--    average rental rate is above the overall average rental rate of all
--    films, otherwise “Standard”.

select cat.category_id as category,
cat.name as category_name, 
count(ff.film_id) as film_count,
avg(ff.rental_rate) as rental_rate,
(
        case
        when avg(ff.rental_rate)>(
                select avg(f.rental_rate)
                from film f
        ) then 'Premium'
        else 'Standard'
        end
) as tier
from film ff inner join film_category fc
on ff.film_id=fc.film_id
inner join category cat
on cat.category_id=fc.category_id
group by cat.category_id;


-- 5. Find the top 3 customers in each store ranked by total amount paid.
--    Display store ID, customer full name, total paid, and their rank within
--    the store.



-- 6. List all pairs of actors who have appeared together in at least 3 films.
--    Show both actors’ full names and the number of films they share.
--    Avoid listing the same pair twice (A-B and B-A).


SELECT
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2,
    COUNT(*) AS shared_films
FROM film_actor fa1
INNER JOIN film_actor fa2
    ON fa1.film_id = fa2.film_id
   AND fa1.actor_id < fa2.actor_id
INNER JOIN actor a1
    ON fa1.actor_id = a1.actor_id
INNER JOIN actor a2
    ON fa2.actor_id = a2.actor_id
GROUP BY
    fa1.actor_id,
    fa2.actor_id,
    a1.first_name,
    a1.last_name,
    a2.first_name,
    a2.last_name
HAVING COUNT(*) >= 3;

-- 7. Convert the special_features column of the film table into a normalized
--    result set that shows one row per film-feature combination. Display
--    film title and the individual special feature.



-- 8. Create a single result set that contains:
--      • All film titles that have never been rented, and
--      • All customer full names who have never made a rental.
--    Clearly label each row as either “Unrented Film” or “Inactive Customer”.


select ff.title AS name,
    'Unrented Film' AS type
from film ff 
left join inventory inv
on inv.film_id=ff.film_id
left join rental r
on r.inventory_id=inv.inventory_id
where r.rental_date is null
group by ff.title
union all
select concat(cu.first_name,' ',cu.last_name) as name,
'Inactive Customer' AS type
from customer cu left join rental re
on re.customer_id=cu.customer_id
where re.rental_id is null;


-- 9. Write a query that returns the film title, its current inventory count
--    across all stores, and a status message:
--      “Out of Stock” if count = 0,
--      “Low Stock” if count between 1 and 3,
--      “In Stock” if count > 3.

select ff.title as title,
COUNT(inv.inventory_id) AS inv_count,
(
        case
        when count(inv.inventory_id)=0 then 'Out of Stock'
        when count(inv.inventory_id) between 1 and 3 then 'Low Stock'
        else 'In Stock'
        end
) as status_inv
from film ff inner join inventory inv 
on ff.film_id=inv.film_id
group by ff.title ;


-- 10. Inside a transaction, increase the rental_rate of every film in the
--     “Action” category by 10%, but only if the new rate would not exceed
--     $5.00. If any film would exceed $5.00, roll back the entire change.
--     After the transaction, show the number of films that were actually
--     updated.



START TRANSACTION;

-- Check whether any Action film would exceed $5
SELECT COUNT(*) INTO @too_expensive
FROM film f
JOIN film_category fc
    ON fc.film_id = f.film_id
JOIN category c
    ON c.category_id = fc.category_id
WHERE c.name = 'Action'
  AND f.rental_rate * 1.10 > 5.00;

-- Only update if none would exceed $5
UPDATE film
SET rental_rate = rental_rate * 1.10
WHERE film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c
        ON c.category_id = fc.category_id
    WHERE c.name = 'Action'
)
AND @too_expensive = 0;

-- Check how many were updated
SET @updated = ROW_COUNT();

-- Commit or rollback
IF @too_expensive = 0 THEN
    COMMIT;
ELSE
    ROLLBACK;
END IF;

SELECT @updated AS films_updated;

