-- Active: 1787069770352@@localhost@3306@sakila
================================================================================
15 MORE INTERMEDIATE PRACTICE QUESTIONS
MySQL + Sakila Sample Database
Topics: Filtering • Joins • Subqueries • Sets
(Questions only – no solution hints)
================================================================================

USE sakila;

-- 1. List the full name and email of every active customer who lives in a
--    city located in “Canada” or “Mexico”.

select cust.first_name,cust.last_name,cust.email
from customer cust inner join address ad
on ad.address_id=cust.address_id
inner join city ci
on ci.city_id=ad.city_id
inner join country con
on con.country_id =ci.country_id
WHERE cust.active = 1
AND (con.country = 'Canada' OR con.country = 'Mexico')
group by cust.first_name,cust.last_name, cust.email 
;

-- 2. Show the title and length of all films that are shorter than the
--    shortest film in the “Sci-Fi” category.

select fl.title, fl.length 
from film fl inner join film_category fc
on fl.film_id=fc.film_id
inner join category ca
on ca.category_id=fc.category_id
where fl.length<(
    select min(fl1.length)
    from film fl1 inner join film_category fc1
    on fl1.film_id=fc1.film_id
    inner join category ca1
    on ca1.category_id=fc1.category_id
    where ca1.name='Sci-Fi'

)
group by fl.title, fl.length;


-- 3. Find the customer ID and full name of customers who have made more
--    payments than the average number of payments per customer.

select cust.customer_id,concat(cust.first_name,' ',cust.last_name) as full_name
from customer cust inner join payment pa
on pa.customer_id = cust.customer_id
group by cust.customer_id,cust.first_name,cust.last_name
having count(pa.payment_id) >(
    SELECT AVG(payment_count)
    FROM (
        SELECT
            pp.customer_id,
            COUNT(pp.payment_id) AS payment_count
        FROM payment pp
        GROUP BY pp.customer_id
    ) AS customer_payment_counts

);

-- 4. Display the film ID and title of every film that has been rented by
--    at least one customer from store 1 and at least one customer from store 2.

select fl.film_id, fl.title 
from film fl inner join inventory inv
on fl.film_id=inv.film_id
inner join rental re
on re.inventory_id=inv.inventory_id
inner join customer cu
on cu.customer_id=re.customer_id
WHERE cu.store_id IN (1, 2)
GROUP BY fl.film_id, fl.title
HAVING COUNT(DISTINCT cu.store_id) = 2;


-- 5. Retrieve the actor’s full name and the titles of all films they appeared
--    in that are rated “PG-13”. Only include actors who have appeared in more
--    than five such films.

SELECT 
    CONCAT(ac.first_name, ' ', ac.last_name) AS full_name,
    fl.title
FROM actor ac
JOIN film_actor fa
    ON fa.actor_id = ac.actor_id
JOIN film fl
    ON fl.film_id = fa.film_id
WHERE fl.rating = 'PG-13'
  AND ac.actor_id IN (
      SELECT fa1.actor_id
      FROM film_actor fa1
      JOIN film ff
          ON ff.film_id = fa1.film_id
      WHERE ff.rating = 'PG-13'
      GROUP BY fa1.actor_id
      HAVING COUNT(*) > 5
  )
ORDER BY full_name, fl.title;

-- 6. List the titles of films that belong to the “Family” category but do not
--    belong to the “Children” category.

select ff.title 
from film ff inner join film_category fc
on fc.film_id=ff.film_id
inner join category ca
on ca.category_id=fc.category_id
where ca.name ='Family' and ca.name<>'Children';


-- 7. Show the full name and total amount spent by every customer who has
--    rented more films than customer ID 1.

select concat(cc.first_name,' ',cc.last_name) as full_name, sum(pp.amount) as total_amount
from customer cc inner join payment pp
on pp.customer_id=cc.customer_id
where cc.customer_id in (
    select cs.customer_id 
    from customer cs inner join rental re
    on re.customer_id=cs.customer_id
    group by cs.customer_id
    having count(re.rental_id)>(
        select count(rental_id) 
        from rental where customer_id=1))
group by cc.first_name,cc.last_name
;


-- 8. Find the staff members who have collected more total revenue than the
--    staff member with staff_id = 1. Display their full name and total revenue.

select concat(cc.first_name,' ',cc.last_name) as full_name, sum(pp.amount) as total_amount
from staff cc inner join payment pp
on cc.staff_id=pp.staff_id
where cc.staff_id in (
    select ss.staff_id from staff ss inner join payment pa
    on pa.staff_id=ss.staff_id
    group by ss.staff_id
    having sum(pa.amount)>(
        select sum(p.amount) from payment p inner join staff s
        on s.staff_id=p.staff_id
        where s.staff_id=1
    )
)
group by cc.first_name,cc.last_name;



-- 9. Retrieve the distinct titles of all films that have been rented by
--    customers living in “Japan” or by customers living in “China”.

select distinct(ff.title) as titles
from film ff inner join inventory inv
on inv.film_id=ff.film_id
inner join rental re
on re.inventory_id=inv.inventory_id
where re.rental_id in (
    select ren.rental_id from rental ren inner join customer cc
    on cc.customer_id=ren.customer_id
    inner join address ad
    on ad.address_id=cc.address_id
    inner join city ci
    on ci.city_id=ad.city_id
    inner join country co
    on co.country_id=ci.country_id
    where co.country='Japan' or co.country='China'
    group by re.rental_id,cc.customer_id
);


-- 10. List the category names that contain more films than the average number
--     of films per category.

select ca.name as cat_name
from category ca inner join film_category fc
on fc.category_id=ca.category_id
inner join film ff
on ff.film_id=fc.film_id
where ca.category_id in (
    select cc.category_id from category cc inner join film_category fcc
    on fcc.category_id=cc.category_id 
    inner join film ff
    on ff.film_id=fcc.film_id
    group by cc.category_id
    having count(ff.film_id)>(
        select avg(film_count) 
        FROM (
            SELECT COUNT(*) AS film_count
            FROM film_category
            GROUP BY category_id
        ) AS counts

    )
);


-- 11. Show the customer ID and full name of customers who have never rented
--     a film from the “Documentary” category.

select cc.customer_id, concat(cc.first_name,' ',cc.last_name) as full_name
from customer cc inner join rental re
on re.customer_id=cc.customer_id
where re.rental_date is not null 

and not exists (
    select cu.customer_id from customer cu inner join rental ren
    on ren.customer_id=cu.customer_id
    inner join inventory inv
    on inv.inventory_id=ren.inventory_id
    inner join film ff
    on ff.film_id=inv.film_id
    inner join film_category fc
    on fc.film_id=ff.film_id
    inner join category ca
    on ca.category_id=fc.category_id
    where ca.name='Documentary'
)>0
group by cc.customer_id,cc.first_name,cc.last_name;

-- 12. Display the film titles that appear in the “Music” category or the
--     “Games” category, but not in both.

-- 13. Find the full names of actors who have appeared in films from every
--     category that exists in the database.

-- 14. List the rental ID, rental date, and customer full name for every
--     rental that lasted longer than the average rental duration of all
--     completed rentals.

-- 15. Retrieve the distinct customer IDs of people who have rented films
--     released in 2006 and have also rented films released in 2005.