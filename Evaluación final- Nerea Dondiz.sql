USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT `title`
FROM `film`;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT *
FROM film;

SELECT `title`
FROM `film`
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE length > 120; 

-- 5. Recupera los nombres de todos los actores.

SELECT first_name, last_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title
FROM film
WHERE rating NOT IN ("R", "PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.

SELECT COUNT(*) AS TotalPeliculas, rating
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT COUNT(r.rental_id) AS CantidadAlquilada, r.customer_id, c.first_name, c.last_name
FROM rental AS r
LEFT JOIN customer AS c ON r.customer_id = c.customer_id
GROUP BY r.customer_id, c.first_name, c.last_name;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT *
FROM category;

SELECT COUNT(rental_id) AS CantidadTotal, c.name
FROM rental AS r
LEFT JOIN inventory AS i ON r.inventory_id = i.inventory_id
LEFT JOIN film AS f ON f.film_id = i.film_id
LEFT JOIN film_category AS fc ON fc.film_id = f.film_id
LEFT JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.

SELECT AVG(length) AS DuracionMedia, rating
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name, a.last_name, f.title
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id
INNER JOIN film AS f ON f.film_id = fa.film_id
WHERE f.title LIKE '%Indian Love%';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.

-- subconsulta
SELECT actor_id 
FROM film_actor;

-- consulta
SELECT a.first_name, a.last_name, a.actor_id
FROM actor AS a
WHERE a.actor_id NOT IN(
	SELECT actor_id
	FROM film_actor
);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title, c.name
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

-- subconsulta
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 10;

--

SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id= a.actor_id
WHERE a.actor_id IN (
	SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(fa.film_id)> 10);

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.

SELECT *
FROM film;

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name, AVG(f.length) AS PromedioDuracion -- AVG(ROUND(f.length, 2)) Para redondear
FROM category AS c
INNER JOIN film_category AS fc ON fc.category_id = c.category_id
INNER JOIN film AS f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

	SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS CantidadPeliculas
	FROM actor AS a
	INNER JOIN film_actor AS fa ON fa.actor_id= a.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
    HAVING COUNT(fa.film_id)>= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT *
FROM rental;

SELECT rental_id
FROM rental;



-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

-- actores que han actuado en películas de la categoría "Horror"

SELECT a.actor_id, a.first_name, a.last_name, c.name
FROM actor AS a
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id
INNER JOIN film_category AS fc ON fc.film_id = fa.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = "Horror";

-- Consulta completa

SELECT a.first_name, a.last_name, a.actor_id
FROM  actor AS a
WHERE a.actor_id NOT IN (
	SELECT DISTINCT fa.actor_id
    FROM film_actor AS fa
    JOIN film_category AS fc ON fc.film_id = fa.film_id
    JOIN category AS c ON c.category_id = fc.category_id
    WHERE c.name = 'Horror'
);

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.

SELECT title
FROM film AS f
INNER JOIN film_category AS fc ON fc.film_id = f.film_id
INNER JOIN category AS c ON c.category_id = fc.category_id
WHERE c.name = 'Comedy' 
	AND f.length > 180;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.