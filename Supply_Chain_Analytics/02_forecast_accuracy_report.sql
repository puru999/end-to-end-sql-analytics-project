-- =========================================================
-- Supply Chain Analytics | Forecast Accuracy Report
-- =========================================================

-- Business Problem:
-- Businesses need to evaluate forecast accuracy
-- by comparing actual sales with forecasted demand.

-- Objective:
-- Calculate forecast accuracy KPIs for customers
-- using actual sales and forecast quantities.

-- KPI:
-- Total Sold Quantity
-- Total Forecast Quantity
-- Net Error
-- Net Error Percentage
-- Absolute Error
-- Absolute Error Percentage
-- Forecast Accuracy

-- Dataset Used:
-- fact_act_est
-- dim_customer

-- SQL Concepts Used:
-- Common Table Expressions (CTEs)
-- Aggregations
-- ABS()
-- CAST()
-- IF()
-- Percentage Error Calculations
-- Supply Chain KPI Analytics

-- Table Aliases:
-- s = fact_act_est
-- c = dim_customer

WITH forecast_err_table AS (

    SELECT

        s.customer_code AS customer_code,

        c.customer AS customer_name,

        c.market AS market,

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
            1
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

    GROUP BY customer_code
)

SELECT
    *,

    IF(
        abs_error_pct > 100,
        0,
        100.0 - abs_error_pct
    ) AS forecast_accuracy

FROM forecast_err_table

ORDER BY forecast_accuracy DESC;
