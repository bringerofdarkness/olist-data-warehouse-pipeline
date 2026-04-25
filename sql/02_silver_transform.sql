

-- =========================
-- Silver Layer Transform
-- =========================

-- 1. Clean Orders
DROP TABLE IF EXISTS silver.clean_orders;

CREATE TABLE silver.clean_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::timestamp AS order_date,
    order_approved_at::timestamp AS approved_date,
    order_delivered_carrier_date::timestamp AS carrier_date,
    order_delivered_customer_date::timestamp AS delivered_date,
    order_estimated_delivery_date::timestamp AS estimated_date
FROM bronze.raw_orders
WHERE order_id IS NOT NULL;


-- 2. Clean Order Items
DROP TABLE IF EXISTS silver.clean_order_items;

CREATE TABLE silver.clean_order_items AS
SELECT
    order_id,
    order_item_id::int,
    product_id,
    seller_id,
    shipping_limit_date::timestamp AS shipping_limit_date,
    price::numeric AS price,
    freight_value::numeric AS freight_value
FROM bronze.raw_order_items;


-- 3. Clean Customers
DROP TABLE IF EXISTS silver.clean_customers;

CREATE TABLE silver.clean_customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix::int AS zip_code,
    customer_city,
    customer_state
FROM bronze.raw_customers;


-- 4. Clean Products
DROP TABLE IF EXISTS silver.clean_products;

CREATE TABLE silver.clean_products AS
SELECT
    product_id,
    product_category_name,
    product_name_length::int,
    product_description_length::int,
    product_photos_qty::int,
    product_weight_g::numeric,
    product_length_cm::numeric,
    product_height_cm::numeric,
    product_width_cm::numeric
FROM bronze.raw_products;


-- 5. Final Products (with category translation)
DROP TABLE IF EXISTS silver.final_products;

CREATE TABLE silver.final_products AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, 'unknown') AS category,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM silver.clean_products p
LEFT JOIN bronze.raw_product_category_translation t
ON p.product_category_name = t.product_category_name;


-- 6. Clean Sellers
DROP TABLE IF EXISTS silver.clean_sellers;

CREATE TABLE silver.clean_sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix::int AS zip_code,
    seller_city,
    seller_state
FROM bronze.raw_sellers;


-- 7. Clean Payments
DROP TABLE IF EXISTS silver.clean_order_payments;

CREATE TABLE silver.clean_order_payments AS
SELECT
    order_id,
    payment_sequential::int,
    payment_type,
    payment_installments::int,
    payment_value::numeric
FROM bronze.raw_order_payments;


-- 8. Order Details (joined intermediate table)
DROP TABLE IF EXISTS silver.order_details;

CREATE TABLE silver.order_details AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_date,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value
FROM silver.clean_orders o
JOIN silver.clean_order_items oi
ON o.order_id = oi.order_id;