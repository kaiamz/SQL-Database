-- Are there any countries without an official language?

SELECT DISTINCT
	country.code, name
FROM
	country
WHERE
	NOT EXISTS
		(SELECT *
		FROM countrylanguage
		WHERE countrylanguage.countrycode = country.code AND isofficial)


-- How many countries have no cities?
    SELECT
    	code, name
    FROM
    	country
    WHERE
    	code NOT IN
    		(SELECT countrycode
    		FROM city)

-- Which countries have the 100 biggest cities in the world?
        SELECT DISTINCT
        	code
        FROM
        	(SELECT
        	cities.population AS population,
        	c.code AS code,
        	cities.countrycode AS countrycode,
        	c.name AS name,
        	cities.name as cityname
        FROM
        	country c JOIN city cities ON (c.code = cities.countrycode)
        ORDER BY
        	population DESC
        LIMIT 100) AS top_city_countries

-- What languages are spoken in the countries with the 100 biggest cities in the world?
CREATE VIEW mycountry AS
(SELECT DISTINCT
        	code
        FROM
        	(SELECT
        	cities.population AS population,
        	c.code AS code,
        	cities.countrycode AS countrycode,
        	c.name AS name,
        	cities.name as cityname
        FROM
        	country c JOIN city cities ON (c.code = cities.countrycode)
        ORDER BY
        	population DESC
        LIMIT 100) AS top_city_countries);

select countrycode, language

FROM countrylanguage

WHERE countrycode IN(
	SELECT code FROM  mycountry)
ORDER BY
	countrycode ASC


-- Which countries have the highest proportion of official language speakers? The lowest?
SELECT
	cl.percentage AS percentage,
	cl.countrycode AS countrycode,
	cl.isofficial AS official,
	c.name AS countryname,
	c.code AS code

FROM
	countrylanguage cl JOIN country c ON (cl.countrycode = c.code)
WHERE
	cl.isofficial
ORDER BY
	percentage DESC
--Determine which countries are in both lists (smallest area and smallest population)

WITH area AS
(SELECT
	code,
	surfacearea,
	name
FROM
	country
ORDER BY
	surfacearea ASC
LIMIT
	10),

pop AS
(SELECT
	code,
	population,
	name

FROM
	country

ORDER BY
	population ASC
LIMIT
	10)

SELECT
	code, name
FROM
	area
WHERE code IN
	(SELECT code
	FROM pop)

--Determine which countries are in neither list
WITH area AS
(SELECT
	code,
	surfacearea,
	name
FROM
	country
ORDER BY
	surfacearea ASC
LIMIT
	10),

pop AS
(SELECT
	code,
	population,
	name

FROM
	country

ORDER BY
	population ASC
LIMIT
	10)

SELECT
	code, name
FROM
	country
WHERE code NOT IN
	(SELECT code FROM pop)
	AND
	code NOT IN
	(SELECT code FROM area)

--What languages are spoken in the 20 poorest (GNP/ capita) countries in the world?
WITH gnp_population AS
(WITH a_population AS
	(SELECT
		code,
		name,
		population,
		gnp
	FROM
		country
	WHERE
		population > 0)

	SELECT
		code,
		name,
		population,
		gnp,
		gnp/population AS gnp_per_capita
	FROM
		a_population
	ORDER BY
		gnp_per_capita ASC limit 20 )

SELECT
	countrycode, language
FROM
	countrylanguage
WHERE countrycode IN (SELECT
			code FROM gnp_population)

--What are the cities in the countries with no official language?
WITH no_official_language AS
(SELECT DISTINCT
	country.code, name
FROM
	country
WHERE
	NOT EXISTS
		(SELECT *
		FROM countrylanguage
		WHERE countrylanguage.countrycode = country.code AND isofficial))

SELECT
	name,
	countrycode
FROM
	city
WHERE countrycode IN (SELECT countrycode FROM no_official_language)
