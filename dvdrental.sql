--WHich customer placed the orders on the earliest date? What did they order?

WITH cust_rent_invent AS (

	WITH my_temp AS
		(SELECT
			c.customer_id AS customer_id,
			r.customer_id AS id,
			c.first_name AS first_name,
			c.last_name AS last_name,
			r.rental_date AS rental_date,
			r.inventory_id AS my_invent

		FROM
			customer c JOIN rental r ON (c.customer_id = r.customer_id)
		ORDER BY
			r.rental_date ASC)

	SELECT
		customer_id,
		first_name,
		last_name,
		my_invent,
		rental_date,
		inventory.film_id AS film
	FROM
		my_temp JOIN inventory ON (inventory.inventory_id = my_temp.my_invent)
	)


	SELECT
		customer_id,
		first_name,
		last_name,
		my_invent,
		film,
		film.title,
		rental_date
	FROM
		cust_rent_invent JOIN film ON (cust_rent_invent.film = film.film_id)
