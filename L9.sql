-- Active: 1787069770352@@localhost@3306@sakila
-- 1. For each customer, calculate their total spending and assign them a
--    lifetime value segment using NTILE(5). Then, within each segment, rank
--    the customers by the number of distinct films they have rented.
--    Display customer full name, total spent, segment number, distinct film
--    count, and the rank inside the segment.

with segment_cust as (
    select sum(pay.amount) as total_spent,
    concat(cu.first_name,' ',cu.last_name) as full_name,
    cu.customer_id,
    ntile(5) over(order by sum(pay.amount) desc

    ) as segment
    from customer cu left join payment pay
    on pay.customer_id=cu.customer_id
    group by cu.customer_id,cu.first_name,cu.last_name
),
ranked_cust as (
    select sc.segment as segment_num,
    sc.total_spent,
    sc.full_name,
    sc.customer_id,
    count(distinct(ff.film_id)) as distinct_film_count,
    rank() over (partition by sc.segment 
    order by count(distinct(ff.film_id)) desc 
    ) 
    from segment_cust sc left join payment pay
    on sc.customer_id=pay.customer_id
    left join rental re 
    on re.rental_id=pay.rental_id
    left join inventory inv 
    on inv.inventory_id=re.inventory_id
    left join film ff
    on ff.film_id=inv.film_id
    group by sc.segment,sc.customer_id,sc.full_name, sc.total_spent
)
select * from ranked_cust;
