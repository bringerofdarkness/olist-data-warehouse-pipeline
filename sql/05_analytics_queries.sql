/*
=========================================================
 OLIST E-COMMERCE ANALYTICS QUERIES
=========================================================

Purpose:
This file contains business-facing analytics queries built
on top of the gold layer.

Important:
gold.fact_orders grain is order-item-payment level.
So payment_value can be duplicated if joined/aggregated carelessly.

Rules:
1. Use COUNT(DISTINCT order_id) for total orders.
2. Use item-level revenue from price when analyzing product/category revenue.
3. Be careful with payment_value because one order may have multiple rows.
4. Use gold tables only for portfolio analytics queries.
=========================================================
*/