-- =========================================================
-- Finance Analytics | Yearly Gross Sales Report
-- =========================================================

-- Business Problem:
-- Analyze yearly gross sales performance
-- for Croma India across fiscal years.

-- Objective:
-- Calculate total yearly gross sales
-- to evaluate overall revenue growth trends.

-- KPI:
-- Gross Sales Amount

-- Dataset Used:
-- fact_sales_monthly
-- fact_gross_price

-- SQL Concepts Used:
-- INNER JOIN
-- Aggregations
-- SUM()
-- GROUP BY
-- User Defined Functions
-- Financial KPI Calculations
-- Sorting and Filtering

-- Table Aliases:
-- s = fact_sales_monthly
-- g = fact_gross_price

SELECT
    get_fiscal_year(s.date) AS fiscal_year,

    ROUND(
        SUM(g.gross_price * s.sold_quantity),
        2
    ) AS gross_sales_amount

FROM fact_sales_monthly s

JOIN fact_gross_price g
    ON g.product_code = s.product_code
    AND g.fiscal_year = get_fiscal_year(s.date)

WHERE
    s.customer_code = 90002002

GROUP BY get_fiscal_year(s.date)

ORDER BY fiscal_year;
