# Retail-Sales-Analysis
Retail sales analysis using SQL, Excel, Power Query and Power BI

An end-to-end data analysis project: cleaning raw retail sales data, querying it in MySQL, and visualizing findings in an interactive Power BI dashboard.

![Dashboard Preview](screenshots/dashboard_preview.png)

## Tools Used
- **Excel** — data cleaning and preparation
- **MySQL** — data querying and analysis (aggregation, CTEs, window functions, subqueries)
- **Power BI** — interactive dashboard and visualization

## Project Overview
The raw dataset (50,000 order records) contained order-level details but was missing a calculated sales value and a readable month field. Steps taken:

1. **Cleaned the data in Excel** — added a `Total Sales` column (Quantity × Unit Price) and an `Order Month` field derived from the order date; verified no missing or duplicate records.
2. **Loaded the cleaned data into MySQL** and wrote 20+ SQL queries to explore sales performance — from basic aggregation to more advanced techniques including CTEs, window functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`), and subqueries.
3. **Built a Power BI dashboard** with KPI cards, product and regional breakdowns, a monthly sales trend line, and a written key-insights panel.

> **Note on currency:** the source dataset did not specify a currency for sales values, so all figures are reported in the dataset's original units rather than assuming one.

## Key Findings
- **Shoes** is the top-selling product, generating the highest revenue share (~29% of total sales).
- The **South region** contributes the largest share of total sales (44.16%).
- Monthly sales peaked in **February 2024**, the highest-performing month in the dataset.

## Highlighted SQL Queries
The full set of 20+ queries is in [`sql/retail_sales_queries.sql`](sql/retail_sales_queries.sql). A few worth calling out:

**Ranking products with a window function (CTE + ROW_NUMBER):**
```sql
WITH product_sales AS (
    SELECT Product, SUM(TotalSales) AS totsales
    FROM retail_sales_data
    GROUP BY Product
    ORDER BY totsales DESC
),
product_sales2 AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY totsales DESC) AS rank_num
    FROM product_sales
)
SELECT * FROM product_sales2;
```

**Month-over-month sales change (CTE + LAG):**
```sql
WITH sales AS (
    SELECT OrderMonth, MIN(OrderDate) AS month_date, SUM(TotalSales) AS tot_sales
    FROM retail_sales_data
    GROUP BY OrderMonth
),
sales2 AS (
    SELECT *, LAG(tot_sales) OVER (ORDER BY month_date) AS prev_month_sales
    FROM sales
)
SELECT *, (tot_sales - prev_month_sales) AS Sales_change
FROM sales2;
```

**Each product's share of total sales (CTE + subquery):**
```sql
WITH sales AS (
    SELECT Product, SUM(TotalSales) AS pro_sales
    FROM retail_sales_data
    GROUP BY Product
)
SELECT *, (pro_sales / (SELECT SUM(TotalSales) FROM retail_sales_data)) * 100 AS sales_percentage
FROM sales;
```

**Products selling above the average product revenue (HAVING + subquery):**
```sql
SELECT Product, SUM(TotalSales) AS totsales
FROM retail_sales_data
GROUP BY Product
HAVING totsales > (
    SELECT AVG(totsales) FROM (
        SELECT Product, SUM(TotalSales) AS totsales
        FROM retail_sales_data
        GROUP BY Product
    ) AS productsales
);
```

## Repository Structure
```
retail-sales-analysis/
├── README.md
├── data/
│   ├── retails_sales_cleaned.xlsx
│   └── retails_sales_cleaned.csv
├── sql/
│   └── retail_sales_queries.sql
├── powerbi/
│   └── retail_sales_dashboard.pbix
└── screenshots/
    └── dashboard_preview.png
```

## Author
Harshita — B.E. Electronics and Communication
[LinkedIn](https://linkedin.com/in/harshita-r-b-383229262)
