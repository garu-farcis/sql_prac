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