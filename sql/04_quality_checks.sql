-- =========================
-- Data Quality Checks
-- =========================

-- Bronze row counts
SELECT 'bronze.raw_orders' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_orders;

SELECT 'bronze.raw_order_items' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_order_items;

SELECT 'bronze.raw_customers' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_customers;

SELECT 'bronze.raw_products' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_products;

SELECT 'bronze.raw_product_category_translation' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_product_category_translation;

SELECT 'bronze.raw_sellers' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_sellers;

SELECT 'bronze.raw_order_payments' AS table_name, COUNT(*) AS row_count
FROM bronze.raw_order_payments;


-- Key null checks
SELECT COUNT(*) AS null_order_id
FROM bronze.raw_orders
WHERE order_id IS NULL;

SELECT COUNT(*) AS null_customer_id
FROM bronze.raw_customers
WHERE customer_id IS NULL;

SELECT COUNT(*) AS null_product_id
FROM bronze.raw_products
WHERE product_id IS NULL;

SELECT COUNT(*) AS null_seller_id
FROM bronze.raw_sellers
WHERE seller_id IS NULL;


-- Duplicate checks
SELECT COUNT(*) AS duplicate_orders
FROM (
    SELECT order_id
    FROM bronze.raw_orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t;

SELECT COUNT(*) AS duplicate_order_items
FROM (
    SELECT order_id, order_item_id
    FROM bronze.raw_order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) t;


-- Silver/Gold checks
SELECT COUNT(*) AS clean_orders_count
FROM silver.clean_orders;

SELECT COUNT(*) AS clean_order_items_count
FROM silver.clean_order_items;

SELECT COUNT(*) AS fact_orders_count
FROM gold.fact_orders;

SELECT COUNT(*) AS unknown_product_categories
FROM silver.final_products
WHERE category = 'unknown';