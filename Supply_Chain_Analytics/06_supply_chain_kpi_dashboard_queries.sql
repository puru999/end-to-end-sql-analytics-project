-- =========================================================
-- Supply Chain Analytics | KPI Dashboard Queries
-- =========================================================

-- Business Problem:
-- Management teams require high-level KPI summaries
-- for monitoring supply chain forecasting performance.

-- Objective:
-- Generate executive-level KPI metrics for:
-- forecast accuracy,
-- sales performance,
-- and forecast variance analysis.

-- KPI:
-- Total Sold Quantity
-- Total Forecast Quantity
-- Net Error
-- Absolute Error
-- Forecast Accuracy

-- Dataset Used:
-- fact_act_est

-- SQL Concepts Used:
-- Aggregations
-- ABS()
-- CASE Statements
-- KPI Engineering
-- Supply Chain Analytics
-- Dashboard Reporting

------------------------------------------------------------
-- Supply Chain KPI Summary
------------------------------------------------------------

SELECT

    SUM(sold_quantity) AS total_actual_sales,

    SUM(forecast_quantity) AS total_forecast_sales,

    SUM(forecast_quantity - sold_quantity)
        AS total_net_error,

    SUM(
        ABS(forecast_quantity - sold_quantity)
    ) AS total_abs_error,

    ROUND(
        (
            100
            -
            (
                SUM(
                    ABS(forecast_quantity - sold_quantity)
                ) * 100
                /
                SUM(forecast_quantity)
            )
        ),
        2
    ) AS overall_forecast_accuracy

FROM fact_act_est

WHERE fiscal_year = 2021;
