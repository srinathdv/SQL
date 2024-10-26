-- 1. report account representative of each customer
-- --------------------------------------------------------------------------
-- customerName,employeeName so JOIN employees+customers-->employeeNumber
-- --------------------------------------------------------------------------
SELECT customers.salesRepEmployeeNumber,customers.customerName,CONCAT(employees.firstName,' ',lastName) AS 'Sales-rep Name'
FROM classicmodels.customers
JOIN employees
ON employees.employeeNumber = customers.salesRepEmployeeNumber
ORDER BY customers.customerName;


-- 2. Report total payments for Atelier graphique
-- --------------------------------------------------------------------------
-- SUM of amount bcz customer may have made multiple transac
-- JOIN customers+payments-->customerNumber
-- GROUP BY customerName or customerNumber
-- --------------------------------------------------------------------------
SELECT customers.customerName, SUM(payments.amount) as 'payment'
FROM payments
JOIN customers
ON payments.customerNumber = customers.customerNumber
WHERE customers.customerName = 'Atelier graphique'
GROUP BY payments.customerNumber;


-- 3. report total payments by Date
-- --------------------------------------------------------------------------
-- SUM amount bcz many transac on single date
-- GROUP BY date
-- --------------------------------------------------------------------------
SELECT paymentDate,SUM(AMOUNT) AS 'Amount'
FROM payments
GROUP BY paymentDate
ORDER BY paymentDate;


-- 4. Reports products that have not been sold
-- 1st approach
-- --------------------------------------------------------------------------
-- get orderdetails and match it to products by condition NOT EXISTS 
-- --------------------------------------------------------------------------
SELECT *
FROM products
WHERE NOT EXISTS (SELECT *
					FROM classicmodels.orderdetails
					WHERE products.productCode = orderdetails.productCode); -- products.productCode only works with full code,gives errors if it is run separetely

-- 2nd approach
-- --------------------------------------------------------------------------
-- get productCode in orderdetils(its in orderdetails indicates they are sold) 
-- check condition productCode NOT IN to get not sold
-- --------------------------------------------------------------------------
SELECT *
FROM products
WHERE products.productCode NOT IN (SELECT DISTINCT orderdetails.productCode 
									FROM classicmodels.orderdetails);


-- 5. list amount paid by each customer
-- --------------------------------------------------------------------------
-- customerName, SUM of amount bcz one customer-multiple payments
-- JOIN customers+payments-->customerNumber GROUP BY customerNumber bcz they are repeated
-- --------------------------------------------------------------------------
SELECT customers.customerName,ROUND(SUM(payments.amount),2) AS 'Amount Paid'
FROM classicmodels.customers
JOIN classicmodels.payments
ON customers.customerNumber = payments.customerNumber
GROUP BY customers.customerNumber
ORDER BY customers.customerName;


-- 6. how many orders have been placed by  Herkku Gifts
-- --------------------------------------------------------------------------
-- customerName,SUM of quantityOrdered bcz multiple orders present
-- customers and orderdetails don't have common column (quantityOrdered is in orderdetails)
-- first JOIN orderdetails+orders-->orderNumber, orders+customers-->customerNumber
-- now apply condition,, GROUP BY customerName bcz we want sum of the quantities
-- --------------------------------------------------------------------------
SELECT customers.customerName,SUM(orderdetails.quantityOrdered) AS total_orders
FROM classicmodels.orderdetails
JOIN classicmodels.orders ON orderdetails.orderNumber = orders.orderNumber
JOIN classicmodels.customers ON orders.customerNumber = customers.customerNumber
WHERE customerName = 'Herkku Gifts'
GROUP BY customers.customerName;


-- 7. who are employees in Boston
-- 1st approach
-- --------------------------------------------------------------------------
-- employeeName,city so JOIN employees+offices-->officeCode and apply condition
-- --------------------------------------------------------------------------
SELECT CONCAT(employees.firstName,' ',employees.lastName) as 'Employee Name', offices.city
FROM classicmodels.employees
JOIN offices
ON employees.officeCode = offices.officeCode
WHERE offices.city = 'Boston';

-- 2nd approach
-- --------------------------------------------------------------------------
-- fisrt get officeCode from offices WHERE city is Boston
-- pass the officeCode to employees
-- --------------------------------------------------------------------------
SELECT CONCAT(employees.firstName,' ',employees.lastName) AS 'Employee Name'
FROM classicmodels.employees
WHERE employees.officeCode IN (SELECT offices.officeCode
								FROM classicmodels.offices
								WHERE city = 'Boston');
                                
                                
-- 8.Report those payments greater than $100,000.
-- Sort the report so the customer who made the highest payment appears first.
-- --------------------------------------------------------------------------
-- customerName,SUM(amount) so JOIN customers+payments-->customerNumber
-- aplly condition and GROUP BY customerName
-- --------------------------------------------------------------------------
SELECT customers.customerName,SUM(payments.amount) AS 'Amount'
FROM classicmodels.customers
JOIN classicmodels.payments
ON payments.customerNumber = customers.customerNumber
WHERE payments.amount>100000
GROUP BY customers.customerName
ORDER BY AMOUNT DESC;


-- 9. list values of 'On Hold' orders
-- 1st approach
-- --------------------------------------------------------------------------
-- get orderNumber whose status is ON Hold
-- get productCode by using above o/p
-- get productName by using above o/p
-- --------------------------------------------------------------------------
SELECT products.productName
FROM classicmodels.products
WHERE products.productCode IN(SELECT orderdetails.productCode
								FROM classicmodels.orderdetails
								WHERE orderdetails.orderNumber IN(SELECT orders.orderNumber 
																FROM classicmodels.orders
																WHERE orders.status = 'On Hold'))
ORDER BY products.productName;

-- 2nd approach
-- --------------------------------------------------------------------------
-- orderNumber,productName 
-- we an't join products and orders
-- so JOIN orders+orderdetails-->orderNumber, orderdetails+products-->productCode
-- apply condition
-- --------------------------------------------------------------------------
SELECT DISTINCT(orders.orderNumber),products.productName
FROM classicmodels.orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON products.productCode = orderdetails.productCode
WHERE orders.status = 'On Hold'
ORDER BY products.productName;


-- 10. Report the number of orders 'On Hold' for each customer.
-- --------------------------------------------------------------------------
-- customerName,COUNT of customerName
-- JOIN customers+orders-->customerNumber apply condition
-- GROUP BY customerName to get count of how many times it is repeated
-- --------------------------------------------------------------------------
SELECT customers.customerName, COUNT(*) AS 'Orders on Hold'
FROM classicmodels.customers
JOIN classicmodels.orders ON customers.customerNumber = orders.customerNumber
WHERE orders.status = 'On Hold'
GROUP BY customers.customerName;