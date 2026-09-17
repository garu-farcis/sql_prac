-- Active: 1787069770352@@localhost@3306@sakila
-- 2. Identify every rental that is more than two standard deviations above
--    the average payment amount for that customer. Show customer full name,
--    payment amount, payment date, the customer’s average payment, and the
--    standard deviation of their payments.

with customer_stats as (

    select
        cu.customer_id,
        concat(cu.first_name,' ',cu.last_name) as full_name,
        avg(pay.amount) as payment_avg,
        std(pay.amount) as standard_dev
    from customer cu
    left join payment pay
        on pay.customer_id = cu.customer_id
    group by
        cu.customer_id,
        cu.first_name,
        cu.last_name

),

avg_payment as (

    select
        cs.full_name,
        pay.rental_id,
        pay.payment_date,
        pay.amount as payment,
        cs.payment_avg,
        cs.standard_dev
    from customer_stats cs
    left join payment pay
        on pay.customer_id = cs.customer_id

),

renta_segg as (

    select
        ap.rental_id as rental,
        ap.full_name,
        ap.payment,
        ap.payment_date,
        ap.payment_avg,
        ap.standard_dev,
        (2 * ap.standard_dev) as two_std
    from avg_payment ap
    where ap.payment > (ap.payment_avg + (2 * ap.standard_dev))

)

select *
from renta_segg;