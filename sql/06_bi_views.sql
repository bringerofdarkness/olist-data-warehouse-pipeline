-- =========================================================
-- KPI Summary View
-- =========================================================

CREATE OR REPLACE VIEW gold.vw_kpi_summary AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM gold.fact_orders
WHERE price IS NOT NULL;


-- =========================================================
-- Monthly Revenue View
-- =========================================================

CREATE OR REPLACE VIEW gold.vw_monthly_revenue AS
SELECT
    DATE_TRUNC('month', order_date)::date AS month_start,
    ROUND(SUM(price), 2) AS monthly_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_orders
WHERE price IS NOT NULL
  AND order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)::date
ORDER BY month_start;


-- =========================================================
-- Revenue by Category View
-- =========================================================

CREATE OR REPLACE VIEW gold.vw_revenue_by_category AS
SELECT
    category,
    ROUND(SUM(price), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_orders
WHERE price IS NOT NULL
  AND category IS NOT NULL
GROUP BY category;