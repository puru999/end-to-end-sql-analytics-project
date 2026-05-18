-- =========================================================
-- Supply Chain Analytics | Net Error Analysis
-- =========================================================

-- Business Problem:
-- Businesses need to analyze forecast deviations
-- between forecasted demand and actual sales.

-- Objective:
-- Calculate net forecast error and
-- absolute forecast error for customers.

-- KPI:
-- Total Sold Quantity
-- Total Forecast Quantity
-- Net Error
-- Net Error Percentage
-- Absolute Error
-- Absolute Error Percentage

-- Dataset Used:
-- fact_act_est
-- dim_customer

-- SQL Concepts Used:
-- Aggregations
-- ABS()
-- CAST()
-- Percentage Error Calculations
-- Supply Chain KPI Analytics
-- ORDER BY

-- Table Aliases:
-- s = fact_act_est
-- c = dim_customer

SELECT

    s.customer_code,

    c.customer,

    c.market,

    SUM(s.sold_quantity) AS total_sold_qty,

    SUM(s.forecast_quantity) AS total_forecast_qty,

    SUM(
        CAST(s.forecast_quantity AS SIGNED)
        -
        CAST(s.sold_quantity AS SIGNED)
    ) AS net_error,

    ROUND(
        SUM(
            CAST(s.forecast_quantity AS SIGNED)
            -
            CAST(s.sold_quantity AS SIGNED)
        ) * 100
        / SUM(s.forecast_quantity),
        2
    ) AS net_error_pct,

    SUM(
        ABS(
            CAST(s.forecast_quantity AS SIGNED)
            -
            CAST(s.sold_quantity AS SIGNED)
        )
    ) AS abs_error,

    ROUND(
        SUM(
            ABS(
                CAST(s.forecast_quantity AS SIGNED)
                -
                CAST(s.sold_quantity AS SIGNED)
            )
        ) * 100
        / SUM(s.forecast_quantity),
        2
    ) AS abs_error_pct

FROM fact_act_est s

JOIN dim_customer c
    ON s.customer_code = c.customer_code

WHERE s.fiscal_year = 2021

GROUP BY
    s.customer_code,
    c.customer,
    c.market

ORDER BY abs_error_pct DESC;
