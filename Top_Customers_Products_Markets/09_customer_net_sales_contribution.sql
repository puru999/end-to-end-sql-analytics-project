-- =========================================================
-- Top Customers, Products, Markets | Customer Net Sales Contribution
-- =========================================================

-- Business Problem:
-- Analyze customer contribution percentage
-- toward total company net sales.

-- Objective:
-- Calculate each customer's percentage share
-- of total net sales for Fiscal Year 2021.

-- KPI:
-- Net Sales Amount
-- Percentage Contribution

-- Dataset Used:
-- net_sales

-- SQL Concepts Used:
-- Window Functions
-- OVER()
-- SUM() OVER()
-- Percentage Contribution Analysis
-- Financial KPI Calculations
-- Aggregations
-- ORDER BY

SELECT
    customer,

    ROUND(
        SUM(net_sales) / 1000000,
        2
    ) AS net_sales_mln,

    ROUND(
        SUM(net_sales)
        * 100
        / SUM(SUM(net_sales)) OVER (),
        2
    ) AS pct_net_sales

FROM net_sales

WHERE fiscal_year = 2021

GROUP BY customer

ORDER BY pct_net_sales DESC;
