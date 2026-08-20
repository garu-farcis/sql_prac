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

