-- =========================================================
-- Finance Analytics | Net Sales Analysis
-- =========================================================

-- Business Problem:
-- Analyze net sales performance after applying
-- pre-invoice discounts for customers in Fiscal Year 2021.

-- Objective:
-- Calculate net sales amount by deducting
-- pre-invoice discount percentages from gross sales.

-- KPI:
-- Gross Sales Amount
-- Pre-Invoice Discount Percentage
-- Net Invoice Sales

-- Dataset Used:
-- fact_sales_monthly
-- fact_gross_price
-- fact_pre_invoice_deductions
-- dim_customer

-- SQL Concepts Used:
-- Common Table Expressions (CTEs)
-- INNER JOIN
-- Aggregations
-- Financial KPI Calculations
-- Discount Calculations
-- User Defined Functions
-- ROUND()
-- IFNULL()

-- Table Aliases:
-- s   = fact_sales_monthly
-- g   = fact_gross_price
-- pre = fact_pre_invoice_deductions
-- c   = dim_customer

WITH gross_sales AS (

    SELECT
        s.date,

        s.customer_code,

        c.customer,

        s.product_code,

        s.sold_quantity,

        g.gross_price,

        ROUND(
            g.gross_price * s.sold_quantity,
            2
        ) AS gross_price_total

    FROM fact_sales_monthly s

    JOIN fact_gross_price g
        ON g.product_code = s.product_code
        AND g.fiscal_year = get_fiscal_year(s.date)

    JOIN dim_customer c
        ON c.customer_code = s.customer_code

    WHERE get_fiscal_year(s.date) = 2021
),

net_sales AS (

    SELECT
        gs.date,

        gs.customer_code,

        gs.customer,

        gs.product_code,

        gs.sold_quantity,

        gs.gross_price,

        gs.gross_price_total,

        IFNULL(pre.pre_invoice_discount_pct, 0)
            AS pre_invoice_discount_pct,

        ROUND(
            gs.gross_price_total
            - (gs.gross_price_total * IFNULL(pre.pre_invoice_discount_pct,0)),
            2
        ) AS net_invoice_sales

    FROM gross_sales gs

    LEFT JOIN fact_pre_invoice_deductions pre
        ON pre.customer_code = gs.customer_code
        AND pre.fiscal_year = get_fiscal_year(gs.date)
)

SELECT
    customer,

    ROUND(
        SUM(gross_price_total),
        2
    ) AS gross_sales_amount,

    ROUND(
        AVG(pre_invoice_discount_pct) * 100,
        2
    ) AS avg_discount_pct,

    ROUND(
        SUM(net_invoice_sales),
        2
    ) AS net_sales_amount

FROM net_sales

GROUP BY customer

ORDER BY net_sales_amount DESC;
