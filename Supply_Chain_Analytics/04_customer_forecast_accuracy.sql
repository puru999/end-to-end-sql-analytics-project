-- =========================================================
-- Supply Chain Analytics | Customer Forecast Accuracy Ranking
-- =========================================================

-- Business Problem:
-- Businesses need to identify customers
-- with high and low forecast accuracy
-- for operational planning improvements.

-- Objective:
-- Rank customers based on forecast accuracy
-- using actual sales and forecast demand.

-- KPI:
-- Forecast Accuracy
-- Total Sold Quantity
-- Total Forecast Quantity
-- Absolute Error Percentage

-- Dataset Used:
-- fact_act_est
-- dim_customer

-- SQL Concepts Used:
-- Common Table Expressions (CTEs)
-- Aggregations
-- ABS()
-- IF()
-- CAST()
-- Supply Chain KPI Analytics
-- ORDER BY
-- Ranking Analysis

-- Table Aliases:
-- s = fact_act_est
-- c = dim_customer

WITH forecast_accuracy_table AS (

    SELECT

        s.customer_code,

        c.customer,

        c.market,

        SUM(s.sold_quantity) AS total_sold_qty,

        SUM(s.forecast_quantity) AS total_forecast_qty,

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
)

SELECT
    *,

    IF(
        abs_error_pct > 100,
        0,
        100 - abs_error_pct
    ) AS forecast_accuracy

FROM forecast_accuracy_table

ORDER BY forecast_accuracy DESC;
