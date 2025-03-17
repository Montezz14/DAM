CREATE DATABASE sakila;
USE sakila;
SHOW TABLES FROM sakila;
-- 1. INSERT: Adding a new actor
INSERT INTO actor (first_name, last_name, last_update) 
VALUES ('Chris', 'Evans', NOW());

-- Verify the inserted record
SELECT * FROM actor WHERE first_name = 'Chris' AND last_name = 'Evans';

-- 2. UPDATE: Modifying an existing actor's last name
UPDATE actor 
SET last_name = 'Hemsworth' 
WHERE first_name = 'Chris' AND last_name = 'Evans';

-- Verify the update
SELECT * FROM actor WHERE first_name = 'Chris';

-- 3. DELETE: Removing an actor
DELETE FROM actor 
WHERE first_name = 'Chris' AND last_name = 'Hemsworth';

-- Verify the deletion
SELECT * FROM actor WHERE first_name = 'Chris';

-- 4. ALTER: Adding a new column for actor nicknames
ALTER TABLE actor ADD COLUMN nickname VARCHAR(50);

-- Verify the column addition
DESCRIBE actor;

-- 5. TRUNCATE: Removing all records from film_text table
TRUNCATE TABLE film_text;

-- Verify the truncate operation
SELECT * FROM film_text;
-- ======================================================
-- 2. DATA INSERTION, DELETION, AND UPDATE
-- ======================================================

-- INSERT: Adding a new actor
INSERT INTO actor (first_name, last_name, last_update) 
VALUES ('Chris', 'Evans', NOW());

-- UPDATE: Modifying the last name of an actor
UPDATE actor 
SET last_name = 'Hemsworth' 
WHERE first_name = 'Chris' AND last_name = 'Evans';

-- DELETE: Removing an actor
DELETE FROM actor 
WHERE first_name = 'Chris' AND last_name = 'Hemsworth';

-- ======================================================
-- 3. CREATING A TABLE FROM A QUERY RESULT
-- ======================================================

-- Create a new table for films released after 2005
CREATE TABLE recent_films AS
SELECT * FROM film WHERE release_year > 2005;

-- ======================================================
-- 4. DESIGNING COMPLEX SQL SCRIPTS
-- ======================================================

-- List all customers who have rented a film in the last 30 days
SELECT DISTINCT customer.* 
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental_date >= CURDATE() - INTERVAL 30 DAY;

-- Identify the most rented film
SELECT film.film_id, film.title, COUNT(rental.rental_id) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.film_id
ORDER BY rental_count DESC
LIMIT 1;

-- Display the total revenue generated per store
SELECT store.store_id, SUM(payment.amount) AS total_revenue
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- ======================================================
-- 5. UNDERSTANDING TRANSACTIONS
-- ======================================================

-- Start a transaction to insert a rental record and update inventory
START TRANSACTION;

-- Insert a new rental
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (NOW(), 5, 1, NULL, 1, NOW());

-- Update inventory to reflect rental
UPDATE inventory 
SET last_update = NOW()
WHERE inventory_id = 5;

-- Commit the transaction
COMMIT;

-- ======================================================
-- 6. ROLLING BACK TRANSACTIONS
-- ======================================================

-- Start a transaction that will be rolled back
START TRANSACTION;

-- Attempt to rent a movie that is out of stock
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (NOW(), 9999, 1, NULL, 1, NOW());

-- Simulate an error check: If the movie is out of stock, rollback
ROLLBACK;

-- ======================================================
-- 7. UNDERSTANDING RECORD LOCKING POLICIES
-- ======================================================

-- Pessimistic Locking: Locking a row to prevent others from modifying it
START TRANSACTION;
SELECT * FROM actor WHERE actor_id = 1 FOR UPDATE;
-- (Keep the transaction open to simulate locking)

-- Optimistic Locking: Checking if the row has changed before updating
UPDATE actor 
SET last_name = 'UpdatedName'
WHERE actor_id = 1 AND last_update = (SELECT last_update FROM actor WHERE actor_id = 1);

-- ======================================================
-- 8. ENSURING DATA INTEGRITY AND CONSISTENCY
-- ======================================================

-- Add a foreign key constraint to ensure referential integrity
ALTER TABLE rental 
ADD CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id);

-- Create a trigger to prevent negative rental payments
DELIMITER //
CREATE TRIGGER prevent_negative_payment
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot be negative';
    END IF;
END;
//
DELIMITER ;

-- ======================================================
-- END OF ASSIGNMENT
-- ======================================================

-- Que conste que le he pedido a chatgpt que lo comente yo no hago eso ni me atribuyo meritos.