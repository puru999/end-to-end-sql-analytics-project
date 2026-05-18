-- =========================================================
-- Supply Chain Analytics | Forecast vs Actual Sales Comparison
-- =========================================================

-- Business Problem:
-- Businesses need to compare actual sales
-- against forecasted demand
-- for operational and inventory planning.

-- Objective:
-- Generate a detailed comparison report
-- showing actual sales,
-- forecast quantities,
-- and variance analysis.

-- KPI:
-- Sold Quantity
-- Forecast Quantity
-- Sales Variance
-- Variance Percentage

-- Dataset Used:
-- fact_act_est
-- dim_customer
-- dim_product

-- SQL Concepts Used:
-- INNER JOIN
-- Aggregations
-- CASE Statements
-- Variance Analysis
-- Percentage Calculations
-- Supply Chain KPI Analytics

-- Table Aliases:
-- s = fact_act_est
-- c = dim_customer
-- p = dim_product

SELECT

    s.date,

    c.customer,

    c.market,

    p.product,

    p.division,

    SUM(s.sold_quantity) AS actual_sales_qty,

    SUM(s.forecast_quantity) AS forecast_sales_qty,

    SUM(s.sold_quantity - s.forecast_quantity)
        AS sales_variance,

    ROUND(
        SUM(s.sold_quantity - s.forecast_quantity)
        * 100
        / SUM(s.forecast_quantity),
        2
    ) AS variance_pct,

    CASE
        WHEN SUM(s.sold_quantity)
             > SUM(s.forecast_quantity)
        THEN 'Above Forecast'

        WHEN SUM(s.sold_quantity)
             < SUM(s.forecast_quantity)
        THEN 'Below Forecast'

        ELSE 'Forecast Matched'
    END AS forecast_status

FROM fact_act_est s

JOIN dim_customer c
    ON s.customer_code = c.customer_code

JOIN dim_product p
    ON s.product_code = p.product_code

WHERE s.fiscal_year = 2021

GROUP BY
    s.date,
    c.customer,
    c.market,
    p.product,
    p.division

ORDER BY ABS(sales_variance) DESC;
