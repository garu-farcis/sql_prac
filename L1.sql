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

-- 6. Find all customers who have rented more than 30 films but have never
--    paid more than $5.00 in a single payment. Show customer ID, full name,
--    total rentals, and maximum single payment amount.

select cust.customer_id, concat(cust.first_name,' ',cust.last_name) as full_name, COUNT(pay.rental_id) as total_rentals, max(pay.amount) as max_pay_amount
from customer cust inner join payment pay
on pay.customer_id =cust.customer_id
inner join rental ren
on ren.rental_id =pay.rental_id
group by cust.customer_id, cust.first_name, cust.last_name
having count(pay.rental_id) >30 and MAX(pay.amount) <= 5;

-- 7. List the titles of all films that feature both “Nick Wahlberg” and
--    “Julianne Moore” as actors.
select fl.title as film_titles
from film fl inner join film_actor flac
on fl.film_id=flac.film_id
inner join actor act
on act.actor_id=flac.actor_id
group by fl.film_id,fl.title
having SUM(
           CASE
               WHEN act.first_name = 'Nick'
                AND act.last_name = 'Wahlberg'
               THEN 1
               ELSE 0
           END
       ) > 0
   AND SUM(
           CASE
               WHEN act.first_name = 'Julianne'
                AND act.last_name = 'Moore'
               THEN 1
               ELSE 0
           END
       ) > 0;


-- 8. Calculate the average length of films for each rating. Only include
--    ratings that have an average length greater than 115 minutes. Display
--    the rating and the average length, rounded to two decimal places.


select round(avg(fl.length),2) as avg_length,fl.rating
from film fl 
group by fl.rating
having avg(fl.length) > 115;


-- 9. Find the customer who has generated the highest total revenue in each
--    store. Display store ID, customer full name, and total amount paid.
select st.store_id, concat(cust.first_name," ",cust.last_name) as full_name, count(pay.amount) as total_amount
from customer cust inner join payment pay 
on pay.customer_id=cust.customer_id
inner join store st
on st.address_id=cust.address_id
group by cust.first_name
having max(count(pay.amount)) order by pay.amount desc;

SELECT
    x.store_id,
    x.full_name,
    x.total_amount
FROM (
    SELECT
        cust.store_id,
        cust.customer_id,
        CONCAT(cust.first_name, ' ', cust.last_name) AS full_name,
        SUM(pay.amount) AS total_amount
    FROM customer cust
    INNER JOIN payment pay
        ON pay.customer_id = cust.customer_id
    GROUP BY
        cust.store_id,
        cust.customer_id,
        cust.first_name,
        cust.last_name
) x
WHERE x.total_amount = (
    SELECT MAX(y.total_amount)
    FROM (
        SELECT
            cust2.store_id,
            cust2.customer_id,
            SUM(pay2.amount) AS total_amount
        FROM customer cust2
        INNER JOIN payment pay2
            ON pay2.customer_id = cust2.customer_id
        GROUP BY cust2.store_id, cust2.customer_id
    ) y
    WHERE y.store_id = x.store_id
);










