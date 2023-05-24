USE Sakila;

drop procedure if exists rented_action_films;

-- Q1: Convert the query into a simple stored procedure

DELIMITER //
CREATE PROCEDURE rented_action_films()
BEGIN
SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.NAME = "Action"
  GROUP BY first_name, last_name, email;
  END //
  DELIMITER ;
  
CALL rented_action_films();
-- SELECT @action;



-- Q2: Make the previous stored procedure to make it more dynamic, so it works for other string arguments i.e. other categories

drop procedure if exists rented_films_category;

DELIMITER //
CREATE PROCEDURE rented_films_category(IN cat_name VARCHAR(255))
BEGIN
SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.NAME = cat_name
  GROUP BY first_name, last_name, email;
  END //
  DELIMITER ;
  
CALL rented_films_category("Comedy");
-- SELECT @filmcategory;

# sanity check to see how many rows there are when filtering for 'Comedy'
SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.NAME = "Comedy"
  GROUP BY first_name, last_name, email;
  
  
  -- Q3: Write a query to check the number of movies released in each movie category. 
  -- Convert the query in to a stored procedure to filter only those categories 
  -- that have movies released greater than a certain number. Pass that number as an 
  -- argument in the stored procedure
  
  SELECT CA.name, COUNT(FC.film_id) AS count_of_film
  FROM film_category AS FC
  INNER JOIN category AS CA ON FC.category_id = CA.category_id
  GROUP BY name;
  -- WHERE count_of_film
  
drop procedure if exists number_films_by_category;

DELIMITER //
CREATE PROCEDURE number_films_by_category(IN param1 INT) -- in x int, 
BEGIN
SELECT CA.name, COUNT(FC.film_id) AS count_of_film
  FROM film_category AS FC
  INNER JOIN category AS CA ON FC.category_id = CA.category_id
  GROUP BY name
  HAVING count_of_film > param1;
END //
DELIMITER ;

CALL number_films_by_category(60);