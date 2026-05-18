-- =========================================================
-- Top Customers, Products, Markets | Final Net Sales Report
-- =========================================================

-- Business Problem:
-- Calculate final net sales after applying
-- both pre-invoice and post-invoice deductions.

-- Objective:
-- Generate a reusable financial reporting query
-- for final net sales analysis.

-- KPI:
-- Net Invoice Sales
-- Post-Invoice Discount Percentage
-- Final Net Sales

-- Dataset Used:
-- sales_postinv_discount

-- SQL Concepts Used:
-- Financial KPI Calculations
-- Revenue Engineering
-- Discount Calculations
-- Reusable Reporting Layer
-- Arithmetic Operations

SELECT
    *,

    net_invoice_sales
    * (1 - post_invoice_discount_pct)
    AS net_sales

FROM sales_postinv_discount;
