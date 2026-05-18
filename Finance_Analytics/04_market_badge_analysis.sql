-- =========================================================
-- Finance Analytics | Market Badge Analysis
-- =========================================================

-- Business Problem:
-- Identify market performance levels
-- based on total sold quantity in Fiscal Year 2021.

-- Business Rule:
-- Gold Market  = Total Sold Quantity > 5 Million
-- Silver Market = Total Sold Quantity <= 5 Million

-- Objective:
-- Classify markets into Gold or Silver categories
-- based on yearly sales volume performance.

-- KPI:
-- Total Sold Quantity
-- Market Badge

-- Dataset Used:
-- fact_sales_monthly
-- dim_customer

-- SQL Concepts Used:
-- INNER JOIN
-- Aggregations
-- SUM()
-- CASE Statement
-- GROUP BY
-- User Defined Functions
-- Business Rule Classification
-- Sorting and Filtering

-- Table Aliases:
-- s = fact_sales_monthly
-- c = dim_customer

SELECT
    c.market,

    SUM(s.sold_quantity) AS total_sold_quantity,

    CASE
        WHEN SUM(s.sold_quantity) > 5000000
        THEN 'Gold'

        ELSE 'Silver'
    END AS market_badge

FROM fact_sales_monthly s

JOIN dim_customer c
    ON s.customer_code = c.customer_code

WHERE
    get_fiscal_year(s.date) = 2021

GROUP BY c.market

ORDER BY total_sold_quantity DESC;
