-- =========================================================
-- Top Customers, Products, Markets | Sales Pre-Invoice Discount View
-- =========================================================

-- Business Problem:
-- Repeated reporting queries require multiple joins
-- and pre-invoice discount calculations.

-- Objective:
-- Create a reusable SQL view containing:
-- sales,
-- product details,
-- market information,
-- gross sales,
-- and pre-invoice discount percentages.

-- Benefits:
-- Simplifies future reporting queries
-- Improves query readability
-- Supports reusable BI reporting layer

-- Dataset Used:
-- fact_sales_monthly
-- dim_customer
-- dim_product
-- fact_gross_price
-- fact_pre_invoice_deductions

-- SQL Concepts Used:
-- CREATE VIEW
-- INNER JOIN
-- LEFT JOIN
-- Financial KPI Calculations
-- IFNULL()
-- User Defined Functions
-- Reusable Reporting Layer Design

-- Table Aliases:
-- s   = fact_sales_monthly
-- c   = dim_customer
-- p   = dim_product
-- g   = fact_gross_price
-- pre = fact_pre_invoice_deductions

DROP VIEW IF EXISTS sales_preinv_discount;

CREATE VIEW sales_preinv_discount AS

SELECT
    s.date,

    get_fiscal_year(s.date) AS fiscal_year,

    s.customer_code,

    c.market,

    s.product_code,

    p.product,

    p.variant,

    s.sold_quantity,

    g.gross_price AS gross_price_per_item,

    ROUND(
        s.sold_quantity * g.gross_price,
        2
    ) AS gross_price_total,

    IFNULL(
        pre.pre_invoice_discount_pct,
        0
    ) AS pre_invoice_discount_pct

FROM fact_sales_monthly s

JOIN dim_customer c
    ON s.customer_code = c.customer_code

JOIN dim_product p
    ON s.product_code = p.product_code

JOIN fact_gross_price g
    ON g.fiscal_year = get_fiscal_year(s.date)
    AND g.product_code = s.product_code

LEFT JOIN fact_pre_invoice_deductions pre
    ON pre.customer_code = s.customer_code
    AND pre.fiscal_year = get_fiscal_year(s.date);
