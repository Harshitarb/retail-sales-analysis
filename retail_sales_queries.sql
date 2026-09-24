CREATE DATABASE retail_sales;
USE retail_sales;
SHOW DATABASES;
USE retail_sales;

CREATE TABLE retail_sales_data (
    OrderID INT,
    CustomerID VARCHAR(20),
    Product VARCHAR(50),
    Region VARCHAR(20),
    OrderDate DATE,
    OrderMonth VARCHAR(20),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalSales DECIMAL(12,2)
);

SELECT COUNT(*) FROM retail_sales_data;

SELECT * 
FROM retail_sales_data
LIMIT 10;

SELECT
SUM(Totalsales)
FROM retail_sales_data;

SELECT 
SUM(Quantity)
FROM retail_sales_data;

SELECT 
AVG(Unitprice)
FROM retail_sales_data;

SELECT Region,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY Region
ORDER BY totsales DESC
LIMIT 1;

SELECT OrderMonth,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY OrderMonth;

SELECT Product,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY Product
ORDER BY totsales DESC
LIMIT 1;

SELECT CustomerID,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY CustomerID;

SELECT CustomerID,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY CustomerID
ORDER BY totsales DESC
LIMIT 5;

SELECT Region,
SUM(Totalsales) AS totsales,
SUM(Quantity) AS totqua
FROM retail_sales_data
GROUP BY Region;

SELECT Region,
SUM(Totalsales) AS totsales
FROM retail_sales_data
GROUP BY Region
HAVING totsales > 2500000;

SELECT *,
CASE 
WHEN TotalSales >= 300 THEN 'HIGH'
WHEN TotalSales >= 150 THEN 'MEDIUM'
ELSE 'LESS'
END AS Sales_category
FROM retail_sales_data;

SELECT Product,
SUM(TotalSales) AS totsales
FROM retail_sales_data
GROUP BY Product
HAVING totsales > (SELECT AVG(totsales) FROM (SELECT Product,
SUM(TotalSales) AS totsales
FROM retail_sales_data
GROUP BY Product) AS productsales);

WITH product_sales AS(
SELECT Product,
SUM(TotalSales)  AS totsales
FROM retail_sales_data
GROUP by Product
ORDER BY totsales DESC)
SELECT *
FROM product_sales
LIMIT 3;

WITH product_sales AS(
SELECT Product,
SUM(TotalSales)  AS totsales
FROM retail_sales_data
GROUP by Product
ORDER BY totsales DESC),
product_sales2 AS(
SELECT *,
RANK() OVER(ORDER BY totsales DESC) AS rank_num
FROM product_sales)
SELECT *
FROM product_sales2;

WITH product_sales AS(
SELECT Product,
SUM(TotalSales)  AS totsales
FROM retail_sales_data
GROUP by Product
ORDER BY totsales DESC),
product_sales2 AS(
SELECT *,
ROW_NUMBER() OVER(ORDER BY totsales DESC) AS rank_num
FROM product_sales)
SELECT *
FROM product_sales2;

WITH product_sales AS(
SELECT OrderMonth,
MIN(OrderDate) AS month_date,
SUM(TotalSales)  AS totsales
FROM retail_sales_data
GROUP by OrderMonth),
product_sales2 AS(
SELECT *,
LAG(totsales) OVER(ORDER BY month_date) AS prev_month_sales
FROM product_sales)
SELECT *
FROM product_sales2;

WITH product_sales AS(
SELECT OrderMonth,
MIN(OrderDate) AS month_date,
SUM(TotalSales)  AS totsales
FROM retail_sales_data
GROUP by OrderMonth),
product_sales2 AS(
SELECT *,
LEAD(totsales) OVER(ORDER BY month_date) AS next_month_sales
FROM product_sales)
SELECT *
FROM product_sales2;

SELECT Product,
AVG(UnitPrice) AS avg_unitprice
FROm retail_sales_data
GROUP BY Product
ORDER BY avg_unitprice DESC
LIMIT 1;

SELECT Region,
SUM(TotalSales) AS totsales
FROM retail_sales_data
GROUP BY Region
ORDER BY totsales DESC
LIMIT 1;

SELECT Product,
SUM(Quantity) AS totalquantity
FROM retail_sales_data
GROUP BY Product
ORDER BY totalquantity DESC
LIMIT 1;

SELECT OrderMonth,
SUM(TotalSales) AS totsales
FROM retail_sales_data
GROUP BY OrderMonth
ORDER BY totsales DESC
LIMIT 1;

SELECT Region,
AVG(TotalSales) AS avg_sales
FROM retail_sales_data
GROUP BY Region;

SELECT Product,
SUM(TotalSales) AS totsales,
SUM(Quantity) AS totqua
FROM retail_sales_data
GROUP BY Product
HAVING totsales > 1000000;

SELECT Region,
MAX(TotalSales) AS maxsale
FROM retail_sales_data
GROUP BY Region;

WITH sales AS(
SELECT Region,
SUM(TotalSales) AS region_sales
FROM retail_sales_data
GROUP BY Region)
SELECT *,
(region_sales / (SELECT SUM(TotalSales) FROM retail_sales_data)) * 100 AS sales_percentage
FROM sales;

WITH sales AS(
SELECT OrderMonth,
MIN(OrderDate) AS month_date,
SUM(TotalSales) AS tot_sales
FROM retail_sales_data
GROUP BY OrderMonth),
sales2 AS(
SELECT *,
LAG(tot_sales) OVER(ORDER BY month_date) AS prev_month_sales
FROM sales)
SELECT *,
(tot_sales - prev_month_sales) AS Sales_change
FROM sales2;

WITH sales AS(
SELECT Product,
SUM(TotalSales) AS pro_sales
FROM retail_sales_data
GROUP BY Product)
SELECT *,
(pro_sales / (SELECT SUM(TotalSales) FROM retail_sales_data)) * 100 AS sales_percentage
FROM sales;