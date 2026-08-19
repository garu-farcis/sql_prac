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