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