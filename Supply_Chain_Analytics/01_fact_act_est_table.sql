-- =========================================================
-- Supply Chain Analytics | Actual vs Forecast Helper Table
-- =========================================================

-- Business Problem:
-- Sales and forecast data are stored separately,
-- making forecast accuracy analysis difficult.

-- Objective:
-- Create a helper table that combines:
-- actual sales quantity
-- and forecast quantity
-- into a single analytical table.

-- Benefits:
-- Simplifies forecast accuracy reporting
-- Supports supply chain KPI analysis
-- Enables actual vs forecast comparisons

-- Dataset Used:
-- fact_sales_monthly
-- fact_forecast_monthly

-- SQL Concepts Used:
-- CREATE TABLE
-- UNION
-- LEFT JOIN
-- Data Engineering
-- Forecast Analytics
-- NULL Handling

-- Table Aliases:
-- s = fact_sales_monthly
-- f = fact_forecast_monthly

------------------------------------------------------------
-- Drop Existing Helper Table
------------------------------------------------------------

DROP TABLE IF EXISTS fact_act_est;

------------------------------------------------------------
-- Create Actual vs Forecast Helper Table
------------------------------------------------------------

CREATE TABLE fact_act_est
(
    SELECT
        s.date AS date,

        get_fiscal_year(s.date) AS fiscal_year,

        s.product_code AS product_code,

        s.customer_code AS customer_code,

        s.sold_quantity AS sold_quantity,

        f.forecast_quantity AS forecast_quantity

    FROM fact_sales_monthly s

    LEFT JOIN fact_forecast_monthly f

    USING (date, customer_code, product_code)
)

UNION

(
    SELECT
        f.date AS date,

        get_fiscal_year(f.date) AS fiscal_year,

        f.product_code AS product_code,

        f.customer_code AS customer_code,

        s.sold_quantity AS sold_quantity,

        f.forecast_quantity AS forecast_quantity

    FROM fact_forecast_monthly f

    LEFT JOIN fact_sales_monthly s

    USING (date, customer_code, product_code)
);

------------------------------------------------------------
-- Replace NULL Values
------------------------------------------------------------

UPDATE fact_act_est

SET sold_quantity = 0

WHERE sold_quantity IS NULL;

UPDATE fact_act_est

SET forecast_quantity = 0

WHERE forecast_quantity IS NULL;
