-- =========================================================
-- Top Customers, Products, Markets | Top Markets by Net Sales
-- =========================================================

-- Business Problem:
-- Identify the top-performing markets
-- based on net sales in Fiscal Year 2021.

-- Objective:
-- Generate a ranked list of top markets
-- by total net sales revenue.

-- KPI:
-- Net Sales Amount (Millions)

-- Dataset Used:
-- net_sales
-- dim_customer

-- SQL Concepts Used:
-- Aggregations
-- GROUP BY
-- ORDER BY
-- Financial KPI Calculations
-- Revenue Analysis
-- Ranking Logic

SELECT
    market,

    ROUND(
        SUM(net_sales) / 1000000,
        2
    ) AS net_sales_mln

FROM gdb0041.net_sales

WHERE fiscal_year = 2021

GROUP BY market

ORDER BY net_sales_mln DESC

LIMIT 5;
