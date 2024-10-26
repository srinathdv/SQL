-- 1. What are the names of salesperson who had atleast one shipment(sale) in the first 7 days of january 2002?
select distinct people.Salesperson
from people
join sales on sales.SPID = people.SPID
where sales.SaleDate between '2022-01-01' and '2022-01-07';


-- 2.Which salesperson did not make any shipments in the first 7 days of january 2002?
select people.Salesperson
from people
where people.SPID not in
	(select distinct sales.SPID
		from sales
		where sales.SaleDate between '2022-01-01' and '2022-01-07');
        

-- 3.How many times we shipped more than 1,000 boxes in each month?
select year(SaleDate) as `Year`,month(SaleDate) as `Month`,count(*) `No_of_times_shipped`
from sales
where sales.Boxes>1000
group by year(SaleDate),month(SaleDate)
order by year(SaleDate),month(SaleDate);


-- 4.Did we ship at least one box of After Nines to New Zealand on all the months?
select products.Product,sum(sales.Boxes) as `no_of_boxes`,year(sales.SaleDate) as `year`,month(sales.SaleDate) as `month`, if (sum(Boxes)>1,'yes','no') 'STATUS'
from sales
join products on sales.PID = products.PID
join geo on sales.GeoID = geo.GeoID
where products.Product = 'After Nines' and geo.Geo = 'New Zealand'
group by year(SaleDate),month(SaleDate)
order by year(SaleDate),month(SaleDate);


-- 5.India or Australia? who buys more chocolate boxes on a monthly basis?
select year(SaleDate),month(SaleDate), 
sum(case when geo.Geo = 'India' =1 then Boxes else 0 end) 'India Boxes',
sum(case when geo.Geo = 'Australia' = 1 then Boxes else 0 end) 'Australia Boxes'
from geo
join sales on geo.GeoID = sales.GeoID
group by year(SaleDate),month(SaleDate)