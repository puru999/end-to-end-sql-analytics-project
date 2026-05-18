-- =========================================================
-- Top Customers, Products, Markets | Performance Optimization #2
-- =========================================================

-- Business Problem:
-- Further improve reporting query performance
-- by storing fiscal year directly in the fact table.

-- Objective:
-- Optimize reporting queries by reducing dependency
-- on repeated fiscal year function calculations.

-- Optimization Strategy:
-- Utilize pre-stored fiscal year values directly
-- from fact_sales_monthly table.

-- Benefits:
-- Faster joins
-- Reduced computation overhead
-- Improved reporting efficiency
-- Better scalability for BI reporting

-- Dataset Used:
-- fact_sales_monthly
-- dim_product
-- fact_gross_price
-- fact_pre_invoice_deductions

-- SQL Concepts Used:
-- INNER JOIN
-- LEFT JOIN
-- Query Optimization
-- Financial KPI Calculations
-- User Defined Functions
-- ROUND()
-- NULL Handling

-- Table Aliases:
-- s   = fact_sales_monthly
-- p   = dim_product
-- g   = fact_gross_price
-- pre = fact_pre_invoice_deductions

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

JOIN dim_product p
    ON s.product_code = p.product_code

JOIN fact_gross_price g
    ON g.product_code = s.product_code
    AND g.fiscal_year = s.fiscal_year

LEFT JOIN fact_pre_invoice_deductions pre
    ON pre.customer_code = s.customer_code
    AND pre.fiscal_year = s.fiscal_year

WHERE
    s.fiscal_year = 2021;
