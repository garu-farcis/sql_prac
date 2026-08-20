-- Active: 1787069770352@@localhost@3306@sakila
-- 1. For each film category, calculate the total number of films and the
--    average rental rate. Only include categories that contain more than 60
--    films. Sort the results by average rental rate (highest first).
SELECT fc.category_id AS category,count(f.film_id) AS film_count,AVG(f.rental_rate) AS average_rental_rate
FROM film_category fc INNER JOIN film f 
ON fc.film_id=f.film_id
GROUP BY fc.category_id
HAVING COUNT (f.film_id)>60 ORDER BY average_rental_rate;

