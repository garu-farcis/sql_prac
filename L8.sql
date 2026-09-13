-- Active: 1787069770352@@localhost@3306@sakila
-- 1. For every payment, show the payment_id, customer full name, amount, and
--    the running total of that customer’s payments ordered by payment_date.

select pa.payment_id, 
concat(cu.first_name,' ',cu.last_name) as full_name,
pa.amount,
sum(pa.amount) over (partition by cu.customer_id  order by pa.payment_date asc 
            rows between unbounded preceding and current row ) as running_total
from customer cu left join payment pa 
on cu.customer_id=pa.customer_id;

-- 2. Rank all films by the number of times they have been rented (most rented
--    first). Display film title, rental count, and the rank. Films with the
--    same rental count must share the same rank, and the next rank must skip
--    accordingly.

select ff.title, 
count(*) as rental_count,
rank() over (order by count(re.rental_id)) as ranking
from film ff left join inventory inv
on ff.film_id=inv.film_id
left join rental re
on inv.inventory_id=re.inventory_id
group by ff.film_id,ff.title
order by ranking;


-- 3. For each customer, show their full name, the date of each rental they
--    made, and the number of days that passed since their previous rental.
--    The first rental for each customer should show NULL for the gap.

select concat(cu.first_name,' ',cu.last_name) as full_name,
re.rental_date,
re.rental_date -lag(re.rental_date) over( PARTITION BY cu.customer_id
    order by re.rental_date desc
) as days_passed
from customer cu left join rental re
on cu.customer_id=re.rental_id
ORDER BY cu.customer_id, re.rental_date ASC;

