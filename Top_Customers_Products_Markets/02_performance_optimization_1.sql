-- =========================================================
-- Top Customers, Products, Markets | Performance Optimization #1
-- =========================================================

-- Business Problem:
-- Improve query performance by reducing repeated
-- fiscal year function calculations during reporting.

-- Objective:
-- Optimize reporting queries by creating a reusable
-- date dimension table and replacing repeated
-- get_fiscal_year() function calls.

-- Optimization Strategy:
-- Create a date dimension table containing:
-- 1. Calendar Date
-- 2. Fiscal Year

-- Benefits:
-- Faster query execution
-- Reduced function computation
-- Improved reporting scalability

-- Dataset Used:
-- fact_sales_monthly
-- dim_date
-- dim_product
-- fact_gross_price
-- fact_pre_invoice_deductions

-- SQL Concepts Used:
-- CREATE TABLE
-- DISTINCT
-- INNER JOIN
-- Query Optimization
-- Dimensional Modeling
-- Financial KPI Calculations

------------------------------------------------------------
-- Create Date Dimension Table
------------------------------------------------------------

CREATE TABLE dim_date AS

SELECT DISTINCT
    date AS calendar_date,

    get_fiscal_year(date) AS fiscal_year

FROM fact_sales_monthly;

------------------------------------------------------------
-- Optimized Reporting Query
------------------------------------------------------------

SELECT
    s.date,

    s.customer_code,

    s.product_code,

    p.product,

    p.variant,

    s.sold_quantity,

    g.gross_price AS gross_price_per_item,

    ROUND(
        s.sold_quantity * g.gross_price,
        2
    ) AS gross_price_total,

    pre.pre_invoice_discount_pct

FROM fact_sales_monthly s

JOIN dim_date dt
    ON dt.calendar_date = s.date

JOIN dim_product p
    ON s.product_code = p.product_code

JOIN fact_gross_price g
    ON g.fiscal_year = dt.fiscal_year
    AND g.product_code = s.product_code

JOIN fact_pre_invoice_deductions pre
    ON pre.customer_code = s.customer_code
    AND pre.fiscal_year = dt.fiscal_year

WHERE
    dt.fiscal_year = 2021

LIMIT 1500000;
