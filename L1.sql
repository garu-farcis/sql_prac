-- Active: 1787069770352@@localhost@3306@sakila
-- 1. For each film category, calculate the total number of films and the
--    average rental rate. Only include categories that contain more than 60
--    films. Sort the results by average rental rate (highest first).
SELECT fc.category_id AS category,count(f.film_id) AS film_count,AVG(f.rental_rate) AS average_rental_rate
FROM film_category fc INNER JOIN film f 
ON fc.film_id=f.film_id
GROUP BY fc.category_id
HAVING COUNT (f.film_id)>60 ORDER BY average_rental_rate;

-- 2. Find the top 10 customers who have spent the most money in total.
--    Display their customer ID, full name, total amount paid, and number of
--    payments. Rank them from highest to lowest spending.

select pay.customer_id,concat(cust.last_name, ', ', cust.first_name) full_name, SUM(pay.amount) AS total_amount_paid,count(pay.payment_id) as no_of_payments
from customer cust inner join payment pay on cust.customer_id=pay.customer_id
group by cust.customer_id order by total_amount_paid DESC limit 10;

-- 3. List every actor who has appeared in more than 30 films. Show the actor’s
--    full name and the exact number of films they appeared in, ordered by
--    number of films descending.

select concat(act.full_name,' ',act.last_name) as full_name,count(flm.film_id) as no_of_films
from film flm inner join film_actor flac
on flm.film_id = flac.film_id
inner join actor ac
on ac.actor_id=flac.actor_id
group by full_name having count(flm.film_id)> 30 order by no_of_films desc;

-- 4. Identify films that have never been rented. Display the film ID, title,
--    and release year of these films.
SELECT
    fl.film_id,
    fl.title,
    fl.release_year
FROM film fl
LEFT JOIN inventory inv
    ON fl.film_id = inv.film_id
LEFT JOIN rental ren
    ON inv.inventory_id = ren.inventory_id
WHERE ren.rental_id IS NULL;
-- 5. For each store, show the total revenue generated and the number of
--    distinct customers who have made at least one payment. Sort by total
--    revenue descending.

select sum(pay.amount) as total_revenue, COUNT(DISTINCT pay.customer_id) as no_of_dist
from customer cust inner join store st
on cust.store_id = st.store_id
inner join payment pay
on pay.customer_id =cust.customer_id
group by cust.store_id 
order by total_revenue desc;
