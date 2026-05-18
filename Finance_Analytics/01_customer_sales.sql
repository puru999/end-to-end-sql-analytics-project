-- =========================================================
-- Finance Analytics | Customer Sales Report
-- =========================================================

-- Business Problem:
-- Analyze monthly customer sales performance
-- for Croma India in Fiscal Year 2021.

-- Objective:
-- Generate a detailed customer sales report including:
-- 1. Month
-- 2. Product Name
-- 3. Product Variant
-- 4. Sold Quantity
-- 5. Gross Price Per Item
-- 6. Gross Price Total

-- Dataset Used:
-- fact_sales_monthly
-- dim_product
-- fact_gross_price

-- SQL Concepts Used:
-- INNER JOIN
-- Aggregations
-- User Defined Functions
-- Financial KPI Calculations
-- Date Formatting
-- Sorting and Filtering

-- Table Aliases:
-- s = fact_sales_monthly
-- p = dim_product
-- g = fact_gross_price

SELECT
    DATE_FORMAT(s.date, '%b %Y') AS month,

    s.product_code,

    p.product,

    p.variant,

    s.sold_quantity,

    g.gross_price AS gross_price_per_item,

    ROUND(
        g.gross_price * s.sold_quantity,
        2
    ) AS gross_price_total

FROM fact_sales_monthly s

JOIN dim_product p
    ON s.product_code = p.product_code

JOIN fact_gross_price g
    ON g.product_code = s.product_code
    AND g.fiscal_year = get_fiscal_year(s.date)

WHERE
    s.customer_code = 90002002
    AND get_fiscal_year(s.date) = 2021

ORDER BY s.date ASC;
