USE classicmodels;

-- 1.list products sold by order date
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- We want Product Name, Order Date & Day of the order.
-- Product Name-->Products Table, Order Date-->Orders Table. we cannot join Products and Orders bcz there is no common column, So we need Orderdetails Table.
-- First JOIN Products+Orderdetails-->ProductCode, then Orderdetails+Orders-->OrderNumber
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT products.productName, orders.orderDate, DAYNAME(orders.orderDate) as 'Dayname'
FROM classicmodels.products
JOIN classicmodels.orderdetails ON products.productCode = orderdetails.productCode
JOIN classicmodels.orders ON orderdetails.orderNumber = orders.orderNumber
ORDER BY orders.orderDate;


-- 2.List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
-- -------------------------------------------------------------------------------------------------
-- We want product Name and Order Date in Desc
-- First JOIN orders+orderdetails-->orderNumber, bcz orderDate is in Orders
-- Next JOIN orderdetails+products-->productCode apply WHERE condition to get specified product only
-- --------------------------------------------------------------------------------------------------
SELECT products.productName, orders.orderDate
FROM classicmodels.orders
JOIN classicmodels.orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN classicmodels.products ON orderdetails.productCode = products.productCode
WHERE products.productName = '1940 Ford Pickup Truck'
ORDER BY orders.orderDate DESC;


-- 3.List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000.
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- We want Customer Name, Order Number and the amount
-- first JOIN customers+orders-->customerNumber, next orders+orderdetails-->orderNumber
-- now GROUP BY orderNumber HAVING amount>25000 --> bcz we only want the order numbers satisfying the condition
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT customers.customerName, orders.orderNumber, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS total
FROM classicmodels.customers
JOIN classicmodels.orders ON customers.customerNumber = orders.customerNumber
JOIN classicmodels.orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY orderdetails.orderNumber
HAVING total > 25000
order by customers.customerName;


-- 4.List the names of products sold at less than 80% of the MSRP.
-- --------------------------------------------------------------------------------------------------------
-- We want Product Name, MSRP
-- sold at 80% < MSRP--> PriceEach of the product is < 0.8*MSRP
-- to get priceEach and to apply condtion on priceEach, JOIN prodcuts+orderdetails-->productCode
-- --------------------------------------------------------------------------------------------------------
SELECT DISTINCT productName,products.MSRP
FROM classicmodels.products
JOIN classicmodels.orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach < (0.8*MSRP)
ORDER BY products.MSRP DESC;


-- 5.Reports those products that have been sold with a markup of 100% or more (i.e the priceEach is at least twice the buyPrice)
-- --------------------------------------------------------------------------------------------------------------------------------------------------------
-- We want productName, buyPrice,priceEach and 2*buyprice
-- here we want to get the products which have the priceEach(selling price of each) > 2*buyprice
-- to get priceEach and to apply condition, JOIN products+orderdetails-->productCode
-- --------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT products.productName,products.buyPrice,2*(products.buyPrice) as twice_bp,orderdetails.priceEach
FROM classicmodels.products
JOIN classicmodels.orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach > (2*products.buyPrice)
ORDER BY twice_bp DESC;


-- 6.List the products ordered on a Monday.
-- -----------------------------------------------------------------------------------------------------------
-- We want product Name, orderDate and Dayname
-- to get orderDate we want orders table, but orders and products has no common column, so we use orderdetails
-- first JOIN products+orderdetails-->productCode, orderdetails+orders-->orderNumber and apply condition
-- -----------------------------------------------------------------------------------------------------------
SELECT products.productName, orders.orderDate, DAYNAME(orders.orderDate)
FROM classicmodels.products
JOIN classicmodels.orderdetails ON products.productCode = orderdetails.productCode
JOIN classicmodels.orders ON orderdetails.orderNumber = orders.orderNumber
WHERE DAYNAME(orders.orderDate) = 'MONDAY';


-- 7.What is the quantity on hand for products listed on 'On Hold' orders?
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- We want productName, quantityInStock, orderstatus
-- to get orderstatus we need orders table, there is no connection btw orders and products so use orderdetails
-- first JOIN products+orderdetails-->productCode, then orderdetails+orders-->orderCode and apply condition
-- -----------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT products.productName, products.quantityInStock,orders.status
FROM classicmodels.products
JOIN classicmodels.orderdetails ON products.productCode = orderdetails.productCode
JOIN classicmodels.orders ON orderdetails.orderNumber = orders.orderNumber
WHERE orders.status = 'On Hold'
ORDER BY products.quantityInStock DESC;


-- 8.List all the products purchased by Herkku Gifts.
-- ---------------------------------------------------------------------------------------------------------------------------------
-- We want customerName,productName
-- there is no connection btw customers and products, customers-->orders,products-->orderdetails,orderdetils-->orders
-- so obtain result join all these tables 
-- JOIN customers+orders-->customerNumber,orders+orderdetails-->orderNumber,orderdetails+products-->productCode now apply condition
-- ---------------------------------------------------------------------------------------------------------------------------------
SELECT  products.productName
FROM classicmodels.customers
JOIN classicmodels.orders ON customers.customerNumber = orders.customerNumber
JOIN classicmodels.orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN classicmodels.products ON orderdetails.productCode = products.productCode
WHERE customers.customerName = 'Herkku Gifts'
ORDER BY products.productName;