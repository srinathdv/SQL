USE classicmodels;

-- 1. find products containing name 'Ford'
-- --------------------------------------------------------------------------
-- LIKE - to get specified pattern
-- --------------------------------------------------------------------------
SELECT productName
FROM classicmodels.products
WHERE productName LIKE '%Ford%';


-- 2. List products ending in 'ship'
SELECT productName 
FROM classicmodels.products
WHERE productName LIKE '%ship';


-- 3. report number of customers in Denmark,Norway,Sweden
-- --------------------------------------------------------------------------
-- IN -- to check in specified values
-- --------------------------------------------------------------------------
SELECT customerName,country 
FROM classicmodels.customers
WHERE country IN ('Denmark','Norway','Sweden')
ORDER BY country;


-- 4. What are the products with a product code in the range S00_1000 to S00_1499
SELECT productCode,productName
FROM classicmodels.products
WHERE RIGHT(productCode,4) BETWEEN 1000 AND 1499  -- 4 is the values we are using i.e 1000 to 1499
ORDER BY RIGHT(productCode,4);


-- 5. Which customers have a digit in their name
-- --------------------------------------------------------------------------
-- RLIKE -- to get pattern in the range specified
-- --------------------------------------------------------------------------
SELECT customerName 
FROM classicmodels.customers
WHERE customerName RLIKE'[0-9]'; -- rlike is used search for complex patterns in string


-- 6. list name of employees called Dianne or Diane
-- 1st approach 
SELECT CONCAT(firstName,' ',lastName) AS 'Employee name'
FROM classicmodels.employees
WHERE lastName RLIKE 'Dianne|Diane' OR 
		firstName RLIKE 'Dianne|Diane';
-- 2nd approach        
SELECT *
FROM employees
WHERE CONCAT(firstName,' ',lastName) RLIKE 'Dianne|Diane';
        
        
-- 7. list products conatining ship or boat in their product name
SELECT *
FROM classicmodels.products
WHERE productName RLIKE 'ship|boat';


-- 8. list products with product code beginning with S700
SELECT *
FROM classicmodels.products
WHERE productCode LIKE 'S700%';


-- 9. list names of employees called Larry or Barry
-- 1st approach
SELECT *
FROM classicmodels.employees
WHERE CONCAT(firstName,' ',lastName) RLIKE 'Larry|Barry';

-- 2nd approach
SELECT * 
FROM classicmodels.employees
WHERE ('Larry') IN (lastName,firstName)
OR ('Barry') IN (lastname,firstName);


-- 10. list names of employees with non-alphabetic characters in their names
SELECT CONCAT(firstName,' ',lastName) AS 'Employee Name'
FROM classicmodels.employees
WHERE CONCAT(firstName,lastName) RLIKE '[0-9%@]';


-- 11. list vendors whose name ends in Diecast
SELECT productVendor as 'Vendors'
FROM classicmodels.products
WHERE productVendor LIKE '%Diecast';