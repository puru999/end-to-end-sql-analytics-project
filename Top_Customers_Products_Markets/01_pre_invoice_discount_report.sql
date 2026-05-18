-- =========================================================
-- Top Customers, Products, Markets | Pre-Invoice Discount Report
-- =========================================================

-- Business Problem:
-- Analyze customer sales transactions along with
-- pre-invoice discount percentages for Fiscal Year 2021.

-- Objective:
-- Generate detailed sales report including:
-- product information,
-- gross sales amount,
-- and applicable pre-invoice discounts.

-- KPI:
-- Gross Price Per Item
-- Gross Price Total
-- Pre-Invoice Discount Percentage

-- Dataset Used:
-- fact_sales_monthly
-- dim_product
-- fact_gross_price
-- fact_pre_invoice_deductions

-- SQL Concepts Used:
-- INNER JOIN
-- Financial KPI Calculations
-- Discount Analysis
-- User Defined Functions
-- ROUND()
-- Sorting and Filtering

-- Table Aliases:
-- s   = fact_sales_monthly
-- p   = dim_product
-- g   = fact_gross_price
-- pre = fact_pre_invoice_deductions

SELECT
    s.date,

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
    ON g.fiscal_year = get_fiscal_year(s.date)
    AND g.product_code = s.product_code

JOIN fact_pre_invoice_deductions pre
    ON pre.customer_code = s.customer_code
    AND pre.fiscal_year = get_fiscal_year(s.date)

WHERE
    get_fiscal_year(s.date) = 2021

LIMIT 1000000;
