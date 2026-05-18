-- =========================================================
-- Top Customers, Products, Markets | Net Invoice Sales Using CTE
-- =========================================================

-- Business Problem:
-- Calculate net invoice sales after applying
-- pre-invoice discounts for Fiscal Year 2021.

-- Objective:
-- Generate a detailed sales report that includes:
-- gross sales,
-- discount percentages,
-- and final net invoice sales.

-- KPI:
-- Gross Price Total
-- Pre-Invoice Discount Percentage
-- Net Invoice Sales

-- Dataset Used:
-- fact_sales_monthly
-- dim_product
-- fact_gross_price
-- fact_pre_invoice_deductions

-- SQL Concepts Used:
-- Common Table Expressions (CTEs)
-- INNER JOIN
-- LEFT JOIN
-- Financial KPI Calculations
-- Discount Calculations
-- IFNULL()
-- ROUND()

-- Table Aliases:
-- s   = fact_sales_monthly
-- p   = dim_product
-- g   = fact_gross_price
-- pre = fact_pre_invoice_deductions

WITH cte1 AS (

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
        AND g.fiscal_year = get_fiscal_year(s.date)

    LEFT JOIN fact_pre_invoice_deductions pre
        ON pre.customer_code = s.customer_code
        AND pre.fiscal_year = get_fiscal_year(s.date)

    WHERE get_fiscal_year(s.date) = 2021
)

SELECT
    *,

    ROUND(
        gross_price_total
        * (1 - IFNULL(pre_invoice_discount_pct, 0)),
        2
    ) AS net_invoice_sales

FROM cte1;
