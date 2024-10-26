USE classicmodels;

-- 1. prepare list of offices sorted by country,state,city
-- --------------------------------------------------------------------------
-- we want territory and sort them using ORDER BY
-- --------------------------------------------------------------------------
SELECT territory as office_locations 
FROM classicmodels.offices
ORDER BY country,state,city;


-- 2. how many employees are there in company
-- --------------------------------------------------------------------------
-- COUNT the emloyeeNumber
-- --------------------------------------------------------------------------
SELECT COUNT(employeeNumber) AS number_of_employees
FROM classicmodels.employees;


-- 3. total payments recieved
-- --------------------------------------------------------------------------
-- SUM of the amount
-- --------------------------------------------------------------------------
SELECT CONCAT('$',round(sum(amount))) AS payment_recieved
FROM classicmodels.payments;


-- 4. list productlines that conains cars
-- --------------------------------------------------------------------------
--  we want productLine having Cars in their name
-- --------------------------------------------------------------------------
SELECT productLine AS Cars 
FROM classicmodels.productlines
WHERE productLine LIKE '%Cars%';


-- 5. report total payments for oct 28 2004
-- --------------------------------------------------------------------------
-- SUM of amount on paymentDate oct 28 2004
-- --------------------------------------------------------------------------
SELECT SUM(payments.amount) AS 'Total Pay on OCT-28-2004'
FROM classicmodels.payments
WHERE paymentDate ='2004-10-28';


-- 6. report payments greater than 100,000
-- --------------------------------------------------------------------------
-- amount > 100000
-- --------------------------------------------------------------------------
SELECT * 
FROM classicmodels.payments
WHERE amount>100000;


-- 7. list the products in each productline
-- --------------------------------------------------------------------------
-- we want productLine,productName
-- --------------------------------------------------------------------------
SELECT products.productLine,products.productName 
FROM classicmodels.products
ORDER BY productLine;


-- 8. how many products in each productline
-- --------------------------------------------------------------------------
-- we want productName, COUNT of productName GROUP BY productLine
-- --------------------------------------------------------------------------
SELECT productLine AS product_names,COUNT(productName) AS no_of_products
FROM classicmodels.products
GROUP BY productLine -- the column is grouped by the productline names, so now the count, counts how many times the productline's name as occurred
ORDER BY no_of_products;


-- 9. minimum payment recieved
-- --------------------------------------------------------------------------
-- MIN of amount
-- --------------------------------------------------------------------------
SELECT MIN(amount) AS min_payment 
FROM classicmodels.payments;


-- 10. all payments greater than 2*avg payment
-- --------------------------------------------------------------------------
-- First get AVG of amount and pass the amount to payments and compare to 2*AVG of amount 
-- --------------------------------------------------------------------------
SELECT *
FROM classicmodels.payments
WHERE amount > 2*(SELECT AVG(amount)
					FROM classicmodels.payments);


-- 11. distinct products of classicmodels
-- --------------------------------------------------------------------------
-- if only DISTINCT i used it gives unique values, if we use COUNT then it gives count of unique values
-- --------------------------------------------------------------------------
SELECT COUNT(DISTINCT productName)
FROM classicmodels.products;


-- 12. name and city of customers who don't have sales representatives
-- --------------------------------------------------------------------------
-- customerName,city WHERE salesREp = NULL
-- --------------------------------------------------------------------------
SELECT customerName,city 
FROM classicmodels.customers
WHERE salesRepEmployeeNumber IS NULL;


-- 13. What are the names of executives with VP or Manager in their title 
-- --------------------------------------------------------------------------
-- Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
-- jobtitle LIKE VP or Manager
-- --------------------------------------------------------------------------
SELECT CONCAT(firstName,' ',lastName) AS `Employee Name`
FROM classicmodels.employees
WHERE jobTitle LIKE '%Manager%' OR jobTitle LIKE 'VP%';


-- 14. orders value greater than 5000
-- --------------------------------------------------------------------------
-- oderNumber, SUM of amount bcz each person may have made multiple transac, so to get total we use sum
-- GROUP BY ordernumber --> groups the colums based on ordernumber, now the the repeated row values will be sent to sum
-- --------------------------------------------------------------------------
SELECT orderdetails.orderNumber AS `order no`, SUM(priceEach*quantityOrdered) AS amount
FROM classicmodels.orderdetails
GROUP BY orderNumber 
HAVING amount> 5000 -- to get the orderNumber which have paid > 5000
ORDER BY amount;


-- 15. the average percentage markup of the MSRP on buyPrice 
-- --------------------------------------------------------------------------
--  Percentage markup is msrp-buyprice and  divides by msrp * 100--> AVG of this is avg per mp
-- --------------------------------------------------------------------------
SELECT AVG((MSRP-buyPrice)/MSRP)*100 AS 'Average Percentage Markup'
FROM classicmodels.products;