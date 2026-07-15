SHOW databases;
USE chinook;
-- =========================
-- CORE SQL QUERIES
-- =========================

-- Basic SELECT, WHERE, ORDER BY
SELECT FirstName, LastName, Country
FROM Customer
WHERE Country = 'USA'
ORDER BY LastName ASC;

-- GROUP BY with HAVING
SELECT Country, COUNT(*) AS CustomerCount
FROM Customer
GROUP BY Country
HAVING COUNT(*) > 5;

-- Aggregate functions
SELECT AVG(Total) AS AvgInvoice, SUM(Total) AS TotalRevenue, COUNT(*) AS InvoiceCount
FROM Invoice;

-- =========================
-- ADVANCED SQL CONCEPTS
-- =========================

-- INNER JOIN
SELECT c.FirstName, c.LastName, i.InvoiceId, i.Total
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId;

-- LEFT JOIN
SELECT ar.Name AS Artist, al.Title AS Album, t.Name AS Track
FROM Artist ar
LEFT JOIN Album al ON ar.ArtistId = al.ArtistId
LEFT JOIN Track t ON al.AlbumId = t.AlbumId;

-- RIGHT JOIN (MySQL/Postgres syntax may vary)
SELECT t.Name AS Track, il.InvoiceLineId
FROM Track t
RIGHT JOIN InvoiceLine il ON t.TrackId = il.TrackId;

-- Subquery
SELECT FirstName, LastName
FROM Customer
WHERE CustomerId IN (
    SELECT CustomerId FROM Invoice WHERE Total > 50
);

-- Window functions (MySQL 8+ / PostgreSQL)
SELECT CustomerId, InvoiceId,
       RANK() OVER (PARTITION BY CustomerId ORDER BY Total DESC) AS RankBySpend
FROM Invoice;

-- =========================
-- 4. BUSINESS PROBLEM SOLVING
-- =========================

-- Top-performing products (tracks by revenue)
SELECT t.Name, SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY Revenue DESC
LIMIT 10;

-- Revenue trends over time
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, SUM(Total) AS MonthlyRevenue
FROM Invoice
GROUP BY Month
ORDER BY Month;

-- Customer purchasing behavior
SELECT c.CustomerId, c.FirstName, c.LastName,
       COUNT(i.InvoiceId) AS Purchases, SUM(i.Total) AS TotalSpend
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalSpend DESC;

-- =========================
-- QUERY OPTIMIZATION
-- =========================

-- Indexes for performance
CREATE INDEX idx_customer_country ON Customer(Country);
CREATE INDEX idx_invoice_date ON Invoice(InvoiceDate);
CREATE INDEX idx_track_album ON Track(AlbumId);

-- Example EXPLAIN to analyze query plan
EXPLAIN SELECT * FROM Invoice WHERE CustomerId = 5;

SELECT Item, SUM(Total) AS Revenue
FROM SalesData
GROUP BY Item
ORDER BY Revenue DESC
LIMIT 10;

SELECT c.CustomerId, c.FirstName, c.LastName,
       COUNT(i.InvoiceId) AS Purchases,
       SUM(i.Total) AS TotalSpend
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalSpend DESC
LIMIT 10;

