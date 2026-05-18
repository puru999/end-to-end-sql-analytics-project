-- =========================================================
-- Top Customers, Products, Markets | Top Products Per Division
-- =========================================================

-- Business Problem:
-- Identify the top-performing products
-- within each division based on total quantity sold.

-- Objective:
-- Rank products by sales quantity
-- and return the top 3 products
-- from each division for Fiscal Year 2021.

-- KPI:
-- Total Quantity Sold
-- Product Rank within Division

-- Dataset Used:
-- fact_sales_monthly
-- dim_product

-- SQL Concepts Used:
-- Common Table Expressions (CTEs)
-- Window Functions
-- DENSE_RANK()
-- PARTITION BY
-- Aggregations
-- GROUP BY
-- Ranking Analytics
-- Product Performance Analysis

-- Table Aliases:
-- s = fact_sales_monthly
-- p = dim_product

WITH cte1 AS (

    SELECT
        p.division,

        p.product,

        SUM(s.sold_quantity) AS total_qty

    FROM fact_sales_monthly s

    JOIN dim_product p
        ON p.product_code = s.product_code

    WHERE get_fiscal_year(s.date) = 2021

    GROUP BY
        p.division,
        p.product
),

cte2 AS (

    SELECT
        *,

        DENSE_RANK() OVER (
            PARTITION BY division
            ORDER BY total_qty DESC
        ) AS division_rank

    FROM cte1
)

SELECT
    division,

    product,

    total_qty,

    division_rank

FROM cte2

WHERE division_rank <= 3

ORDER BY
    division,
    division_rank;
