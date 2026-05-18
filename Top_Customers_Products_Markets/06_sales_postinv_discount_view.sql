-- =========================================================
-- Top Customers, Products, Markets | Sales Post-Invoice Discount View
-- =========================================================

-- Business Problem:
-- Generate a reusable reporting layer containing
-- post-invoice deductions and net invoice sales.

-- Objective:
-- Create a SQL view that combines:
-- pre-invoice discounts,
-- post-invoice discounts,
-- and net invoice sales calculations.

-- Benefits:
-- Simplifies advanced financial reporting
-- Supports reusable analytics layer
-- Improves reporting consistency

-- KPI:
-- Gross Price Total
-- Pre-Invoice Discount Percentage
-- Net Invoice Sales
-- Post-Invoice Discount Percentage

-- Dataset Used:
-- sales_preinv_discount
-- fact_post_invoice_deductions

-- SQL Concepts Used:
-- CREATE VIEW
-- INNER JOIN
-- Financial KPI Calculations
-- Discount Engineering
-- Reusable Reporting Layer Design

-- Table Aliases:
-- s  = sales_preinv_discount
-- po = fact_post_invoice_deductions

DROP VIEW IF EXISTS sales_postinv_discount;

CREATE VIEW sales_postinv_discount AS

SELECT
    s.date,

    s.fiscal_year,

    s.customer_code,

    s.market,

    s.product_code,

    s.product,

    s.variant,

    s.sold_quantity,

    s.gross_price_total,

    s.pre_invoice_discount_pct,

    (
        s.gross_price_total
        - s.pre_invoice_discount_pct * s.gross_price_total
    ) AS net_invoice_sales,

    (
        po.discounts_pct
        + po.other_deductions_pct
    ) AS post_invoice_discount_pct

FROM sales_preinv_discount s

JOIN fact_post_invoice_deductions po
    ON po.customer_code = s.customer_code
    AND po.product_code = s.product_code
    AND po.date = s.date;
