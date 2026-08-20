-- Active: 1787069770352@@localhost@3306@sakila
SELECT * FROM actor LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id;
CREATE TABLE person
(person_id SMALLINT UNSIGNED,
fname VARCHAR(20),
lname VARCHAR(20),
eye_color CHAR(2) CHECK (eye_color IN ('BR','BL','GR')),
birth_date DATE,
street VARCHAR(30),
city VARCHAR(20),
state VARCHAR(20),
country VARCHAR(20),
postal_code VARCHAR(20),
CONSTRAINT pk_person PRIMARY KEY (person_id)
);
INSERT INTO person (person_id, fname, lname, eye_color, birth_date)VALUES (1, 'William','Turner', 'BR', '1972-05-27');
SELECT * FROM person;
CREATE TABLE fav_food(
    person_name VARCHAR(20),
    person_id SMALLINT UNSIGNED,
    food VARCHAR(20),
    CONSTRAINT pk_fav_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES person(person_id)
);
ALTER TABLE fav_food 
DROP FOREIGN KEY fk_person;
ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;
SELECT * FROM fav_food;
SELECT version(),user(),database();
SELECT DISTINCT actor_id FROM film_actor ORDER BY actor_id;
---   Find all active customers whose first name starts with 'A' and last name ends with 'N'.
---   Show: customer_id, first_name, last_name, email
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customer c WHERE c.first_name LIKE 'A%' AND c.last_name LIKE '%N';
-- 2. List films with length between 90 and 120 minutes (inclusive) that have rental_rate = 2.99.
--    Order by length DESC, then title.
--    Show: film_id, title, length, rental_rate
SELECT film_id, title, length, rental_rate FROM film 
WHERE (length BETWEEN 90 AND 120) AND (rental_rate=2.99)
ORDER BY length DESC,title LIMIT 20;
-- 3. Find all films whose rating is NOT in ('G', 'PG').
--    Show: title, rating, replacement_cost
SELECT title, rating, replacement_cost FROM film WHERE rating NOT IN ('G', 'PG');
-- 4. Actors whose last name contains 'ER' and first name does NOT start with 'J'.
--    Show: actor_id, first_name, last_name
SELECT actor_id, first_name, last_name FROM actor WHERE (last_name LIKE '%ER%') AND (first_name NOT LIKE 'J%');
-- 5. Find rentals that have never been returned .
--    Show: rental_id, rental_date, customer_id, inventory_id
--    Limit to 20 rows
SELECT rental_id, rental_date, customer_id, inventory_id FROM rental WHERE date(return_date) IS NULL LIMIT 20;
-- 6. Customers whose last name is 'Smith' OR first name is 'Mary' OR email ends with '@sakilacustomer.org',
--    AND store_id = 1.
--    Show: customer_id, first_name, last_name, email, store_id
SELECT customer_id, first_name, last_name, email, store_id FROM customer 
WHERE ((last_name='Smith') OR (first_name='Mary') OR (email LIKE '%@sakilacustomer.org'))
AND store_id = 1;
-- 7. List every payment made during the month of July 2005. Include payment ID,
--    customer ID, amount, and payment date. Sort the results from highest
--    amount to lowest.
SELECT payment_id,customer_id, amount,payment_date FROM payment WHERE date(payment_date) BETWEEN '2005-07-01' AND '2005-07-31'
ORDER by amount DESC;

