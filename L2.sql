-- Active: 1787069770352@@localhost@3306@sakila
--================================================================================--

--15 INTERMEDIATE PRACTICE QUESTIONS
--MySQL + Sakila Sample Database
--Topics: Filtering • Joins • Subqueries • Sets
--(Questions only – no solution hints)
--================================================================================

USE sakila;

-- 1. Retrieve the full name and email of every customer who lives in a city
--    that belongs to the country “United States”.
select concat(cust.first_name,' ',cust.last_name) as full_name, cust.email as email
from customer cust inner join address ad
on cust.address_id=ad.address_id
where ad.city_id in (
    select ci.country_id
    from address ad1 inner join city ci
    on ad1.city_id = ci.city_id
    inner join country cou
    on ci.country_id = cou.country_id
    where cou.country='United States'
);


-- 2. List the title and rental rate of all films that belong to the “Sports”
--    category and cost more than the average rental rate of all films.
select fl.title as title, fl.rental_rate as rental_rate, cat.name as category_name
from film fl inner join film_category fc
on fl.film_id=fc.film_id
inner join category cat
on cat.category_id=fc.category_id
where cat.name in (
    select cat1.name
    from category cat1 inner join film_category fc1
    on cat1.category_id=fc1.category_id
    group by cat1.name
    having cat1.name='Sports'
) 
and fl.rental_rate >(
    SELECT AVG(rental_rate)
    FROM film
);

-- 3. Show the first name, last name, and total amount paid by each customer
--    who has spent more than $150 in total. Order the results from highest
--    to lowest spender.
select cust.first_name , cust.last_name , sum(pay.amount) as total_amount
from customer cust inner join payment pay 
on cust.customer_id=pay.customer_id
group by cust.first_name , cust.last_name 
having sum(pay.amount) > 150
order by sum(pay.amount) desc;


-- 4. Find the titles of all films that have never been rented by any customer.

select fl.title as titles
from film fl inner join inventory inv
on inv.film_id=fl.film_id
inner join rental ren 
on ren.inventory_id=inv.inventory_id
where ren.rental_date is null;

-- 5. Display the actor’s full name and the number of films they have appeared
--    in. Only include actors who have worked in more than 20 films.
select concat(act.first_name,' ',act.last_name) as full_name, count(fl.film_id) as no_of_films
from film_actor ft inner join film fl
on ft.film_id =fl.film_id
inner join actor act
on act.actor_id=ft.actor_id
group by ft.actor_id
having count(fl.film_id)>20 ;


-- 6. List every film that is available in store 1 but is not available in
--    store 2. Show the film ID and title.

select fl.film_id, fl.title
from film fl inner join inventory inv
on inv.film_id =fl.film_id 
inner join store st
on st.store_id=inv.store_id
group by fl.film_id
having SUM(st.store_id = 1) > 0
   AND SUM(st.store_id = 2) = 0;


-- 7. Retrieve the customer ID and full name of customers who have rented at
--    least one film from the “Horror” category and at least one film from
--    the “Comedy” category.

SELECT
    cust.customer_id,
    CONCAT(cust.first_name, ' ', cust.last_name) AS full_name
FROM customer cust
INNER JOIN payment pay
    ON cust.customer_id = pay.customer_id
INNER JOIN rental ren
    ON ren.rental_id = pay.rental_id
INNER JOIN inventory inv
    ON inv.inventory_id = ren.inventory_id
INNER JOIN film_category fc
    ON fc.film_id = inv.film_id
INNER JOIN category cat
    ON cat.category_id = fc.category_id
GROUP BY cust.customer_id, cust.first_name, cust.last_name
HAVING SUM(cat.name = 'Horror') > 0
   AND SUM(cat.name = 'Comedy') > 0;


-- 8. Show the title, length, and category name of all films that are longer
--    than the longest film in the “Animation” category.

select fl.title, fl.length,cat.name
from film fl inner join film_category fc
on fc.film_id=fl.film_id
inner join category cat
on cat.category_id=fc.category_id
where fl.length > (
    select max(f.length) from film f inner join film_category fc1
on fc1.film_id=f.film_id
inner join category cat1
on cat1.category_id=fc1.category_id
where cat1.name='Animation'
)


-- 9. Find the names of all staff members who have processed more rentals than
--    the average number of rentals processed by all staff members.

select st.first_name, st.last_name
from staff st inner join rental ren
on st.staff_id=ren.staff_id
group by ren.staff_id,st.first_name, st.last_name
having count(ren.rental_id) > (
    select avg(rental_count) FROM (
        SELECT
            staff_id,
            COUNT(rental_id) AS rental_count
        FROM rental
        GROUP BY staff_id
    ) AS staff_rentals
);


-- 10. List the film titles that appear in both the “Action” category and the
--     “Drama” category.

select fl.title from film fl inner join film_category fc
on fc.film_id=fl.film_id
inner join category cat
on cat.category_id=fc.category_id
GROUP BY fl.film_id, fl.title
HAVING
    SUM(
        CASE
            WHEN cat.name = 'Action' THEN 1
            ELSE 0
        END
    ) > 0
    AND
    SUM(
        CASE
            WHEN cat.name = 'Drama' THEN 1
            ELSE 0
        END
    ) > 0;

-- 11. Display the customer full name and the date of their most recent rental
--     for every customer who has made at least one rental.
select concat(cust.first_name,' ',cust.last_name) as full_name,max(ren.rental_date) as rental_date
from customer cust inner join rental ren
on ren.customer_id=cust.customer_id
group by cust.customer_id;


-- 12. Retrieve the titles of films that have been rented by customers living
--     in “Canada” but have never been rented by customers living in “Australia”.
SELECT DISTINCT fl.title
FROM film fl
INNER JOIN inventory inv
    ON fl.film_id = inv.film_id
INNER JOIN rental ren
    ON ren.inventory_id = inv.inventory_id
INNER JOIN customer cust
    ON cust.customer_id = ren.customer_id
INNER JOIN address ad
    ON cust.address_id = ad.address_id
INNER JOIN city ci
    ON ad.city_id = ci.city_id
INNER JOIN country con
    ON ci.country_id = con.country_id
WHERE con.country = 'Canada'
  AND NOT EXISTS (
      SELECT 1
      FROM inventory inv2
      INNER JOIN rental ren2
          ON ren2.inventory_id = inv2.inventory_id
      INNER JOIN customer cust2
          ON cust2.customer_id = ren2.customer_id
      INNER JOIN address ad2
          ON cust2.address_id = ad2.address_id
      INNER JOIN city ci2
          ON ad2.city_id = ci2.city_id
      INNER JOIN country con2
          ON ci2.country_id = con2.country_id
      WHERE inv2.film_id = fl.film_id
        AND con2.country = 'Australia'
  );

-- 13. Show the category name and the total number of films in that category
--     for every category that contains more films than the “Travel” category.
SELECT
    cat.name,
    COUNT(fl.film_id) AS total_films
FROM film fl
INNER JOIN film_category fc
    ON fl.film_id = fc.film_id
INNER JOIN category cat
    ON cat.category_id = fc.category_id
GROUP BY cat.category_id, cat.name
HAVING COUNT(fl.film_id) > (
    SELECT COUNT(fl2.film_id)
    FROM film fl2
    INNER JOIN film_category fc2
        ON fl2.film_id = fc2.film_id
    INNER JOIN category cat2
        ON cat2.category_id = fc2.category_id
    WHERE cat2.name = 'Travel'
);


-- 14. List the first name and last name of all actors who have appeared in
--     films released in 2006 but have not appeared in any films released
--     before 2006.

SELECT ac.first_name, ac.last_name

FROM actor ac
INNER JOIN film_actor fa
    ON fa.actor_id = ac.actor_id

INNER JOIN film fl
    ON fl.film_id = fa.film_id

WHERE fl.release_year = 2006

AND NOT EXISTS (
    SELECT fl1.release_year

    FROM actor ac1
    INNER JOIN film_actor fa1
        ON fa1.actor_id = ac1.actor_id

    INNER JOIN film fl1
        ON fl1.film_id = fa1.film_id

    WHERE ac1.actor_id = ac.actor_id
      AND fl1.release_year < 2006
)

GROUP BY ac.actor_id, ac.first_name, ac.last_name;


-- 15. Find the customer IDs of people who have rented films from store 1
--     and also rented films from store 2. Present the result as a single
--     column of distinct customer IDs.

select distinct cust.customer_id 
from customer cust inner join rental ren
on cust.customer_id= ren.customer_id
inner join inventory inv
on inv.inventory_id=ren.inventory_id
inner join store st
on st.store_id=inv.store_id
where st.store_id in (1,2)
group by cust.customer_id
having count(distinct st.store_id=2)
;
