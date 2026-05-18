-- =========================================================
-- Finance Analytics | Monthly Gross Sales Report
-- =========================================================

-- Business Problem:
-- Analyze monthly gross sales trends
-- for Croma India in Fiscal Year 2021.

-- Objective:
-- Calculate total monthly gross sales
-- to evaluate revenue performance over time.

-- KPI:
-- Gross Sales Amount

-- Dataset Used:
-- fact_sales_monthly
-- fact_gross_price

-- SQL Concepts Used:
-- INNER JOIN
-- Aggregations
-- SUM()
-- GROUP BY
-- Date Formatting
-- User Defined Functions
-- Sorting and Filtering

-- Table Aliases:
-- s = fact_sales_monthly
-- g = fact_gross_price

SELECT
    DATE_FORMAT(s.date, '%b %Y') AS month,

    ROUND(
        SUM(g.gross_price * s.sold_quantity),
        2
    ) AS gross_sales_amount

FROM fact_sales_monthly s

JOIN fact_gross_price g
    ON g.product_code = s.product_code
    AND g.fiscal_year = get_fiscal_year(s.date)

WHERE
    s.customer_code = 90002002
    AND get_fiscal_year(s.date) = 2021

GROUP BY month

ORDER BY s.date ASC;
