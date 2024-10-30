USE mavenmovies;

/*
1.	We will need a list of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 
SELECT first_name,last_name,email,store_id
FROM mavenmovies.staff;


/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 
SELECT store_id, COUNT(*) AS Inventory_items
FROM mavenmovies.inventory
GROUP BY store_id;


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/
SELECT store_id, COUNT(customer_id) AS Active_customers
FROM mavenmovies.customer
WHERE active=1
GROUP BY store_id;


/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/
SELECT COUNT(email) AS Emails
FROM  mavenmovies.customer;


/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/
SELECT store_id,COUNT(DISTINCT film_id) AS Unique_films
FROM mavenmovies.inventory
GROUP BY store_id;

SELECT COUNT(DISTINCT name) AS Unique_category
FROM mavenmovies.category;


/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/
SELECT MIN(replacement_cost)AS Least_expensive,MAX(replacement_cost) AS Most_expensive,AVG(replacement_cost)AS Avg_replacement_cost
FROM mavenmovies.film;


/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/
SELECT AVG(amount) AS Avg_payment, MAX(amount) AS Max_payment
FROM mavenmovies.payment;


/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/
SELECT customer_id,COUNT(rental_id) AS Rentals
FROM mavenmovies.rental
GROUP BY customer_id
ORDER BY Rentals DESC;


/* 
9. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
SELECT staff.store_id,CONCAT(staff.first_name,' ',staff.last_name) AS Staff_name,address.address,address.district,city.city,country.country
FROM mavenmovies.staff
LEFT JOIN mavenmovies.address ON staff.address_id = address.address_id
LEFT JOIN mavenmovies.city ON address.city_id = city.city_id
LEFT JOIN mavenmovies.country ON city.country_id = country.country_id;

	
/*
10.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT inventory.inventory_id,inventory.store_id,film.title,film.rating,film.rental_rate,film.replacement_cost
FROM mavenmovies.inventory
LEFT JOIN mavenmovies.film ON inventory.film_id = film.film_id;


/* 
11.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT film.rating,inventory.store_id,COUNT(inventory.inventory_id) AS Inventory_items
FROM mavenmovies.inventory
LEFT JOIN mavenmovies.film ON inventory.film_id = film.film_id
GROUP BY film.rating,inventory.store_id;


/* 
12. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT inventory.store_id, category.name AS Category,COUNT(inventory.inventory_id) AS Films,AVG(film.replacement_cost) AS Avg_replacement_cost,SUM(film.replacement_cost) AS Total_replacement_cost
FROM mavenmovies.inventory
LEFT JOIN mavenmovies.film ON inventory.film_id = film.film_id
LEFT JOIN mavenmovies.film_category ON film.film_id = film_category.film_id
LEFT JOIN mavenmovies.category ON film_category.category_id = category.category_id
GROUP BY inventory.store_id,category.name
ORDER BY Total_replacement_cost DESC;


/*
13.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT CONCAT(customer.first_name,' ',customer.last_name) AS Customer_name,customer.store_id,customer.active,CONCAT(address.address,' ',city.city,' ',country.country) AS Address
FROM mavenmovies.customer
LEFT JOIN mavenmovies.address ON customer.address_id = address.address_id
LEFT JOIN mavenmovies.city ON address.city_id = city.city_id
LEFT JOIN mavenmovies.country ON city.country_id = country.country_id;


/*
14.We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT CONCAT(customer.first_name,' ',customer.last_name)AS Customer_name,COUNT(rental.customer_id)AS Rentals,SUM(payment.amount)AS Tot_Payment
FROM mavenmovies.customer
LEFT JOIN mavenmovies.rental ON customer.customer_id = rental.customer_id
LEFT JOIN mavenmovies.payment ON rental.rental_id = payment.rental_id
GROUP BY Customer_name
ORDER BY Tot_Payment DESC;

    
/*
15. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT 'Advisor' AS Member_type,CONCAT(first_name,' ',last_name) AS Name, NULL
FROM mavenmovies.advisor
UNION
SELECT 'Investor' AS Member_type,CONCAT(first_name,' ',last_name) AS Name,company_name
FROM mavenmovies.investor;


/*
16. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film	
FROM actor_award
GROUP BY number_of_awards;