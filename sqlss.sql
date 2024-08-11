-- SOLUTION 1

SELECT
MIN(DISTINCT(replacement_cost))
FROM film

-- Solution 2
	
SELECT
COUNT(*),
CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'Low'
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'Medium'
ELSE 'High'
END category
FROM film
GROUP BY category
ORDER BY COUNT(*) DESC
LIMIT 1
	
-- SOLUTION 3
	
SELECT
f.title,
f.length,
c.name
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIn category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY f.length DESC
LIMIT 1
	
-- SOLUTION 4
	
SELECT
c.name,
COUNT(f.title)
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIn category c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY COUNT(f.title) DESC
LIMIT 1	
	
-- SOLUTION 5
	
SELECT
first_name,
last_name,
COUNT(f.film_id)
FROM actor a
INNER JOIN film_actor f
ON a.actor_id = f.actor_id
GROUP BY first_name, last_name
ORDER BY COUNT(f.film_id) DESC
LIMIT 1
	
-- SOLUTION 6
	
SELECT
COUNT(*)
FROM address a
LEFT JOIN customer c
ON a.address_id = c.address_id
WHERE customer_id is NULL
	
-- SOLUTION 7
	
SELECT
cit.city,
SUM(amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city cit
ON a.city_id = cit.city_id
GROUP BY cit.city
ORDER BY SUM(amount) DESC
LIMIT 1
	
-- SOLUTION 8
	
SELECT
ca.country || ', ' || cit.city AS country,
SUM(p.amount)
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city cit
ON a.city_id = cit.city_id
LEFT JOIN country ca
ON cit.country_id = ca.country_id
GROUP BY ca.country, cit.city
ORDER BY SUM(p.amount) DESC
LIMIT 1
	
-- SOLUTION 9
	
SELECT
staff_id,
ROUND(AVG(total_amount),2)
FROM(
SELECT staff_id,
customer_id,
SUM(amount) as total_amount FROM payment
GROUP BY staff_id, customer_id)
GROUP BY staff_id
LIMIT 1
	
-- SOLUTION 10
	
SELECT
	district,
    ROUND(AVG(total), 2)
FROM(
SELECT
district,
c.customer_id,
SUM(p.amount) as total
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
INNER JOIN address a
ON c.address_id = a.address_id
GROUP BY district, c.customer_id)
GROUP BY district
ORDER BY ROUND(AVG(total), 2) DESC
LIMIT 1
	
-- SOLUTION 11
	
SELECT
p.payment_id,
c.name,
SUM(p.amount),
(SELECT
SUM(p2.amount)
FROM payment p2
INNER JOIN rental r2
ON p2.rental_id = r2.rental_id
INNER JOIN inventory i2
ON r2.inventory_id = i2.inventory_id
INNER JOIN film_category f2
ON i2.film_id = f2.film_id
INNER JOIN category c2
ON f2.category_id = c2.category_id
WHERE c.name = c2.name
GROUP BY c2.name)
FROM payment p
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category f
ON i.film_id = f.film_id
INNER JOIN category c
ON f.category_id = c.category_id
GROUP BY c.name, p.payment_id
ORDER BY c.name ASC, p.payment_id ASC
	
-- SOLUTION 12
	
SELECT
	title,
	total,
	name
FROM( SELECT
c.name,
title,
SUM(amount) as total
FROM payment p
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category f
ON i.film_id = f.film_id
INNER JOIN category c
ON f.category_id = c.category_id
INNER JOIN film fi
ON f.film_id = fi.film_id
GROUP BY c.name, title)
WHERE total IN (SELECT
	MAX(total)
FROM( SELECT
c.name,
title,
SUM(amount) as total
FROM payment p
INNER JOIN rental r
ON p.rental_id = r.rental_id
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category f
ON i.film_id = f.film_id
INNER JOIN category c
ON f.category_id = c.category_id
INNER JOIN film fi
ON f.film_id = fi.film_id
GROUP BY c.name, title)
GROUP BY name) AND name = 'Animation'




