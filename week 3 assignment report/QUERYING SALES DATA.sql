USE sales;
-- Basic SELECT, WHERE, ORDER BY
SELECT Rep, Item, Units, Total
FROM SalesData
WHERE Region = 'East'
ORDER BY Total DESC;

-- GROUP BY with HAVING
SELECT Region, COUNT(*) AS Orders
FROM SalesData
GROUP BY Region
HAVING COUNT(*) > 50;

-- Aggregate functions
SELECT AVG(Total) AS AvgSale, SUM(Total) AS TotalRevenue, COUNT(*) AS OrderCount
FROM SalesData;


-- INNER JOIN (if you split into Customers/Products tables later)
-- Example join with same table for demonstration
SELECT s1.Rep, s1.Item, s2.Total
FROM SalesData s1
INNER JOIN SalesData s2 ON s1.Rep = s2.Rep;

-- Subquery
SELECT Rep, Item, Total
FROM SalesData
WHERE Total > (SELECT AVG(Total) FROM SalesData);

-- Window functions (MySQL 8+ / PostgreSQL)
SELECT Rep, Item, Total,
       ROW_NUMBER() OVER (PARTITION BY Rep ORDER BY Total DESC) AS RowNum,
       RANK() OVER (PARTITION BY Rep ORDER BY Total DESC) AS RankBySales
FROM SalesData;


-- BUSINESS PROBLEM SOLVING 
-- Top-performing products
SELECT Item, SUM(Total) AS Revenue
FROM SalesData
GROUP BY Item
ORDER BY Revenue DESC
LIMIT 10;

-- Revenue trends over time
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(Total) AS MonthlyRevenue
FROM SalesData
GROUP BY Month
ORDER BY Month;

-- Customer purchasing behavior (by Rep)
SELECT Rep, COUNT(*) AS Orders, SUM(Total) AS TotalSpend, AVG(Total) AS AvgSpend
FROM SalesData
GROUP BY Rep
ORDER BY TotalSpend DESC;


-- Query Optimization
-- Indexes for performance
CREATE INDEX idx_region ON SalesData(Region);
CREATE INDEX idx_orderdate ON SalesData(OrderDate);
CREATE INDEX idx_item ON SalesData(Item);

-- Analyze query plan
EXPLAIN SELECT * FROM SalesData WHERE Region = 'East';

SELECT AVG(Total) AS AvgOrderValue,
       SUM(Total) AS TotalRevenue,
       COUNT(*) AS OrderCount
FROM SalesData;

SELECT Item, SUM(Total) AS Revenue
FROM SalesData
GROUP BY Item
ORDER BY Revenue DESC
LIMIT 10;

SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
       SUM(Total) AS MonthlyRevenue
FROM SalesData
GROUP BY Month
ORDER BY Month;

SELECT Rep,
       COUNT(*) AS Orders,
       SUM(Total) AS TotalRevenue,
       AVG(Total) AS AvgOrderValue,
       RANK() OVER (ORDER BY SUM(Total) DESC) AS RankByRevenue
FROM SalesData
GROUP BY Rep
ORDER BY TotalRevenue DESC;
