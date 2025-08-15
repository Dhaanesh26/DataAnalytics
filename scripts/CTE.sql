/* Creates a CTE as active customers with active status and Query 

WITH active_customers AS (
	SELECT 
        CustomerName
	FROM customer
    WHERE IsActive = 'TRUE'
)
SELECT *
FROM active_customers
ORDER BY CustomerName;
*/
USE DNA;

SELECT * FROM customer; 
SELECT * FROM orderdetails;
SELECT * FROM product;
SELECT * FROM orderinfo;
/*
SELECT c.CustomerID, c.CustomerName, p.ProductName, DISTINCT(COUNT(OrderDate))
FROM c AS customer JOIN p AS product ON c.CustomerID = p.ProductID 
JOIN orderinfo AS o 
*/

# JOINS question 1
 
SELECT 
	c.CustomerID,
    c.CustomerName,
    p.ProductName,
    COUNT(DISTINCT YEAR(oi.OrderDate)) AS no_of_years
FROM orderinfo AS oi
JOIN customer AS c
    ON oi.CustomerID = c.CustomerID
JOIN orderdetails od
    ON od.OrderID = oi.OrderID
JOIN product AS p 
    ON p.ProductID = od.ProductID
GROUP BY
	c.CustomerID,
    c.CustomerName,
    p.ProductName
ORDER BY
	c.CustomerID,
    c.CustomerName,
    p.ProductName;
	
    
# JOINS Question 2 Find each customer’s total amount spent per product category, sorted by highest spender first.

SELECT c.CustomerName, p.ProductCategory, SUM(p.Price) AS total_amount_by_product_catogory
FROM customer AS c JOIN orderinfo AS oi
	ON c.CustomerID = oi.CustomerID
JOIN orderdetails AS od 
	ON od.OrderID = oi.OrderID
JOIN product AS p
	ON p.ProductID = od.ProductID
GROUP BY c.CustomerName, p.ProductCategory
ORDER BY total_amount_by_product_catogory DESC;  

# JOINS Question 3 Show which product was bought by customer ID 1 in year 2022 and 2025

SELECT c.CustomerID, p.ProductName, oi.OrderDate
FROM customer AS c JOIN orderinfo AS oi
	ON c.CustomerID = oi.CustomerID
JOIN orderdetails AS od 
	ON od.OrderID = oi.OrderID
JOIN product AS p
	ON p.ProductID = od.ProductID
WHERE oi.OrderDate = 2022 AND oi.OrderDate = 2025 AND c.CusyomerID = 1;


SELECT 
    c.CustomerID, 
    p.ProductName
FROM customer AS c
JOIN orderinfo AS oi
    ON c.CustomerID = oi.CustomerID
JOIN orderdetails AS od 
    ON od.OrderID = oi.OrderID
JOIN product AS p
    ON p.ProductID = od.ProductID
WHERE c.CustomerID = 1
  AND YEAR(oi.OrderDate) = 2022;
INTERSECT
SELECT 
    c.CustomerID, 
    p.ProductName
FROM customer AS c
JOIN orderinfo AS oi
    ON c.CustomerID = oi.CustomerID
JOIN orderdetails AS od 
    ON od.OrderID = oi.OrderID
JOIN product AS p
    ON p.ProductID = od.ProductID
WHERE c.CustomerID = 1
  AND YEAR(oi.OrderDate) = 2025;

# Example of CTE 

# This is noraml query without CTE
SELECT c.CustomerName, SUM(p.Price * o.Quantity) AS TotalRevenue
FROM Orders o
-- Join to get customer and products table
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 2024
GROUP BY c.CustomerName
HAVING SUM(p.Price * o.Quantity) > 1000;

# Above query with CTE
WITH OrderDetails AS (
	SELECT c.CustomerName, SUM(p.Price * o.Quantity) AS TotalRevenue
    FROM Orders
    JOIN Customers c ON o.CustomerID = c.CustomerID
	JOIN Products p ON o.ProductID = p.ProductID
	WHERE YEAR(o.OrderDate) = 2024
)
SELECT c.CustomerName, SUM(p.Price * o.Quantity) AS TotalRevenue
FROM OrderDetails
GROUP BY CustomerName
HAVING SUM(Price * Quantity) > 1000;
    
