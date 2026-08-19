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
