-- 1.Print details of shipments(sales) where amount are > 2,000 and boxes are <100.
SELECT *
FROM sales
WHERE Amount > 2000 AND Boxes < 100
ORDER BY Amount,Boxes;


-- 2.How many shipments(sales) each of the sales persons had in the month of january 2022.
SELECT p.Salesperson, COUNT(*) AS 'No_of_sales'
FROM people p
JOIN sales s ON p.SPID = s.SPID
WHERE SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY p.Salesperson;


-- 3.Which product sells more boxes? Milk bars or Eclairs?
SELECT pr.Product, SUM(s.Boxes) AS 'No_of_Boxes'
FROM products pr
JOIN sales s ON pr.PID = s.PID
WHERE pr.product IN ('Milk Bars','Eclairs')
GROUP BY pr.product;


-- 4.Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
SELECT pr.Product,SUM(s.Boxes) AS 'Tot_BOXES'
FROM sales s
JOIN products pr ON s.PID = pr.PID
WHERE pr.Product IN ('Milk Bars','Eclairs')
AND SaleDate BETWEEN '2022-02-01' AND '2022-02-07'
GROUP BY pr.Product;
 
 
-- 5.Which shipments had under 100 customers & under 100 boxes?Did any of them occur on Wednesday
SELECT * 
FROM sales
WHERE Customers<100 AND Boxes<100 AND DAYNAME(SaleDate) = 'WEDNESDAY';
 
select *,
	case when weekday(SaleDate)=2 then 'Wednesday shipment'
		else ''
		end as 'W shipment'
from sales
where Customers<100 and Boxes<100;