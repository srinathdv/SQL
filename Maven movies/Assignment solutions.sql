USE mavenmovies;
/* 
" I'm going to send an email letting our customers know there has been a management change.
Could you pull a list of the first name, last name and email of each of our customers?"
*/
SELECT first_name, last_name, email
FROM mavenmovies.customer;


/*
"My understanding is that we have titles that we rent for durations of 3, 5 or 7 days.
Could you pull the records of our films and see if there are any other rental durations?"
*/
SELECT DISTINCT rental_duration
FROM mavenmovies.film;


/*
"I'd like to look at payment records for our long time customers to learn about their purchase patterns.
Could you pull all payments from our first 100 customers(based on customer id)?"
*/
SELECT customer_id
FROM mavenmovies.payment
WHERE customer_id <= 100;


/*
"The payment data you gave me on our first 100 customers was great-thank you!
Now I'd love to see just payments over $5 for those same customers, since january 1 2006."
*/
SELECT customer_id, rental_id, amount, payment_date
FROM mavenmovies.payment
WHERE customer_id <= 100 AND amount>5 AND payment_date>'2006-01-01';


/*
"The data you shared previously on customers 42,53,60 and 75 was good to see.
Now, could you please write a query to pull all payments from those specific customers, along with payments over $5, from any customer?"
*/
SELECT customer_id, rental_id, amount, payment_date
FROM mavenmovies.payment
WHERE amount>5 OR customer_id IN (42,53,60,75);


/*
"We need to understand the special features in our films.
Could you pull a list of films which include a Behind the Scenes special feature?"
*/
SELECT title,special_features
FROM mavenmovies.film
WHERE special_features LIKE '%Behind the Scenes%';


/*
"I need to get a quick overview of how long our movies tend to be rented out for.
Could you pull out a count of titles sliced by rental duration?"
*/
SELECT rental_duration,COUNT(title) AS Count_of_Titles
FROM mavenmovies.film
GROUP BY rental_duration;


/*
"I'm wondering if we charge more for a rental when the replacement cost is higher.
Can you help me pull a count of films, along with average,min and max rental rate, grouped by replacement cost?"
*/
SELECT COUNT(title) AS NO_OF_FILMS,
		AVG(rental_rate) AS AVG_OF_RENT,
		MIN(rental_rate) AS MIN_RENT,
        MAX(rental_rate) AS MAX_RENT
FROM mavenmovies.film
GROUP BY replacement_cost;


/*
"I'd like to talk to customers that have not rented much from us to understand if there is something we could be doing better.
Could you pull a list of customer ids with less than 15 rentals all time?"
*/
SELECT customer_id,COUNT(rental_id) AS RENTALS
FROM mavenmovies.rental
GROUP BY customer_id
HAVING RENTALS<15;


/*
"I'd like to see if our longest films also tend to be our most expensive rentals.
Could you pull me a list of all film titles along with their lengths and rental rates and sort them from longest to shortest?"
*/
SELECT title,length,rental_rate
FROM mavenmovies.film
ORDER BY length DESC;


/*
"I'd like to know which store each customer goes to and whether or not they are active.
Could you pull a list of first and last names of all customers and label them as either 'store 1 active','store 1 inactive', 'store 2 active', 'store 2 inactive'?"
*/
SELECT CONCAT(first_name,' ',last_name) AS Customer_name,
CASE 
	WHEN store_id =1 AND active=1 THEN 'Store 1 Active'
    WHEN store_id=1 AND active=0 THEN 'Store 1 Inactive'
    WHEN store_id=2 AND active=1 THEN 'Store 2 Active'
    WHEN store_id=2 AND active=0 THEN 'Store 2 Inactive'
    ELSE 'Not active in both'
END AS Store_status
FROM mavenmovies.customer;


/*
"I'm curious how many inactive customers we have at each store.
Could you please create table to count the number of customers broken down by store_id(in rows) and active status(in columns)?"
*/
SELECT store_id,
	COUNT(CASE WHEN active=1 THEN customer_id ELSE NULL END) AS Active,
    COUNT(CASE WHEN active=0 THEN customer_id ELSE NULL END) AS Inactive
FROM mavenmovies.customer
GROUP BY store_id;


/*
"Cam you pull me a list of each film we have in inventory?
I would like to see the film's title,description and store_id value associated with each item and its inventory_id."
*/
SELECT inventory.inventory_id,inventory.store_id,film.title,film.description
FROM mavenmovies.inventory
JOIN mavenmovies.film ON inventory.film_id = film.film_id;


/*
"One of our investors is interested in the films we carry and how many actors are listed for each film title.
Can you pull a list of all titles and figure out how many actors are associated with each title?"
*/
SELECT film.title,COUNT(film_actor.actor_id) AS No_of_Actors
FROM mavenmovies.film
JOIN mavenmovies.film_actor ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;


/*
"Customers often ask which films their favorite actors appear in.
It would be great to have a list of all actors, with each title that they appear in.
*/
SELECT actor.first_name,actor.last_name,film.title
FROM mavenmovies.actor
JOIN mavenmovies.film_actor ON film_actor.actor_id = actor.actor_id
JOIN mavenmovies.film ON film_actor.film_id = film.film_id;


/*
"The Manager from store 2 is working on expanding our film collection there.
Could you pull a list of distinct titles and their descriptions currently available in inventory at store2?"
*/
SELECT DISTINCT film.title,film.description
FROM mavenmovies.film
JOIN mavenmovies.inventory ON film.film_id = inventory.film_id AND inventory.store_id =2;


/*
"We will be hosting a meeting with all of our staff and advisors soon.
Could you pull one list of all staff and advisor names and include a column noting whether they are a staff member or advisor?"
*/
SELECT 'Staff' AS Member_type,first_name,last_name
FROM mavenmovies.staff
UNION
SELECT 'Advisor' AS Member_type,first_name,last_name
FROM mavenmovies.advisor;