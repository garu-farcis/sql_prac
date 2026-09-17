-- Active: 1787069770352@@localhost@3306@sakila
/*-- 3. Build a month-over-month retention report for 2005: for each month show
--    the number of customers who rented in that month, the number who also
--    rented in the previous month, and the retention percentage.
--    Months with no prior activity should still appear.*/

with recursive month_spine as (
    select 1 as month_num
    union all
    select month_num + 1
    from month_spine
    where month_num < 12
),
 cust_details as (
    select cu.customer_id,re.rental_id as rental,
    month(re.rental_date) as rental_months_list
    from customer cu 
    left join rental re
    on re.customer_id=cu.customer_id
    where year(re.rental_date) = 2005
),
cust_count as (
    select count(distinct cd.customer_id) as num_customers_current,
    cd.rental_months_list,
    lag(count(distinct cd.customer_id)) over (order by ms.month_num) as num_customers_previous_month
    from month_spine as ms
    left join cust_details cd
    on cd.rental_months_list=ms.month_num
    group by ms.month_num

 
)

select * from cust_count