-- =========================================================
-- Top Customers, Products, Markets | Customer Net Sales Distribution by Region
-- =========================================================

-- Business Problem:
-- Analyze customer contribution percentage
-- within each geographic region.

-- Objective:
-- Calculate customer net sales contribution
-- relative to their own region for Fiscal Year 2021.

-- KPI:
-- Net Sales Amount
-- Regional Contribution Percentage

-- Dataset Used:
-- net_sales
-- dim_customer

-- SQL Concepts Used:
-- Window Functions
-- PARTITION BY
-- SUM() OVER()
-- Percentage Contribution Analysis
-- Regional Analytics
-- Financial KPI Calculations
-- Aggregations
-- ORDER BY

SELECT
    c.region,

    n.customer,

    ROUND(
        SUM(n.net_sales) / 1000000,
        2
    ) AS net_sales_mln,

    ROUND(
        SUM(n.net_sales)
        * 100
        / SUM(SUM(n.net_sales))
            OVER (PARTITION BY c.region),
        2
    ) AS pct_region_net_sales

FROM net_sales n

JOIN dim_customer c
    ON c.customer_code = n.customer_code

WHERE n.fiscal_year = 2021

GROUP BY
    c.region,
    n.customer

ORDER BY
    c.region,
    pct_region_net_sales DESC;
