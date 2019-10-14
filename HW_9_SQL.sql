USE sakila;

-- 1a
SELECT first_name, last_name from actor;

-- 1b
ALTER TABLE actor
ADD COLUMN Actor_Name VARCHAR(50);

SELECT first_name, last_name,
CONCAT(first_name, ',', last_name) AS Actor_Name FROM actor;

-- 2a
SELECT first_name, last_name, actor_id FROM actor
WHERE first_name='Joe';

-- 2b
SELECT * FROM actor
-- need the % for some reason.
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%LI%";

-- 2d
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name) AS "Count"
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS "Count"
FROM actor
GROUP BY last_name
HAVING Count>1;

-- 4c
SELECT first_name, last_name
FROM actor
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

SELECT first_name, last_name
FROM actor
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

-- 4d
-- Saw this coming
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

SELECT first_name, last_name
FROM actor
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 5a
SHOW CREATE TABLE address;
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) 
ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a
-- Here you select all the columns you need from both tables.
SELECT first_name, last_name, address
FROM staff
JOIN address
-- need the ( ) or it won't work.
USING (address_id);

-- 6b
SELECT first_name, last_name, SUM(amount)
FROM staff
JOIN payment
USING (staff_id)
GROUP BY first_name;

-- 6c
SELECT title, COUNT(actor_id) AS "Total_Actors"
FROM film
JOIN film_actor
USING (film_id)
GROUP BY film_id;

-- 6d
-- How would I display the film title in this one?
SELECT SUM(film_id)
FROM inventory
WHERE film_id IN 
(	SELECT film_id
	FROM film
    WHERE title = "Hunchback Impossible"
);

-- 6e
SELECT first_name, last_name, SUM(amount)
FROM customer
JOIN payment
USING (customer_id)
GROUP BY customer_id;

-- 7a
SELECT title
FROM film
-- Doing WHERE title LIKE "K%" OR "Q%" doesn't work for some reason.
WHERE title LIKE "K%"
OR title like "Q%"
AND language_id IN
(	SELECT language_id
	FROM language
    WHERE name = "ENGLISH"
);

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(	SELECT actor_id
	FROM film_actor
    WHERE film_id IN
    (	SELECT film_id
		FROM film
        WHERE title = "Alone Trip"
	)
);

-- 7c
SELECT first_name, last_name, email, address_id, city_id, country_id
FROM customer
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id)
WHERE country="Canada";

-- 7d
SELECT title
from film
WHERE film_id IN
(
 SELECT film_id
 FROM film_category
 WHERE category_id IN
 (
  SELECT category_id
  FROM category
  WHERE name = "Family"
  )
);

-- 7e
CREATE VIEW 7e AS
SELECT title, film_id, inventory_id, rental_id 
FROM film
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id);

SELECT * FROM 7e;

SELECT title, COUNT(rental_id) AS "Count"
FROM 7e
GROUP BY title
ORDER BY Count DESC;

-- 7f
CREATE VIEW 7f AS
SELECT customer_id, store_id, amount
FROM customer
JOIN payment
USING (customer_id)
JOIN store
USING (store_id);

SELECT * FROM 7f;

SELECT store_id, SUM(amount)
FROM 7f
GROUP BY store_id;

-- 7g
CREATE VIEW 7g AS
SELECT store_id, address_id, address, city_id, city, country_id, country
FROM store
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id);

SELECT store_id, address, city, country FROM 7g;

-- 7h
CREATE VIEW 7h AS
SELECT category_id, name, film_id, inventory_id, rental_id, amount
FROM category
JOIN film_category
USING (category_id)
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
JOIN payment
USING (rental_id);

SELECT * FROM 7h;

SELECT name, SUM(amount) AS "Revenue"
FROM 7h
GROUP BY name
ORDER BY Revenue DESC
LIMIT 5;

-- 8a
CREATE VIEW 8a AS 
SELECT name, SUM(amount) AS "Revenue"
FROM 7h
GROUP BY name
ORDER BY Revenue DESC
LIMIT 5;

SELECT * FROM 8a;

-- 8b
SELECT * FROM 8a;

-- 8c
-- saw this one coming as well
DROP VIEW 8a;