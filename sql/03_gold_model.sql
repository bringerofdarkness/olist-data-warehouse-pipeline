
-- =========================
-- Gold Layer: Star Schema
-- =========================

DROP TABLE IF EXISTS gold.dim_customers;

CREATE TABLE gold.dim_customers AS
SELECT
    customer_id,
    customer_unique_id,
    zip_code,
    customer_city,
    customer_state
FROM silver.clean_customers;



DROP TABLE IF EXISTS gold.dim_products;

CREATE TABLE gold.dim_products AS
SELECT
    product_id,
    category,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM silver.final_products;


DROP TABLE IF EXISTS gold.dim_sellers;

CREATE TABLE gold.dim_sellers AS
SELECT
    seller_id,
    zip_code,
    seller_city,
    seller_state
FROM silver.clean_sellers;




DROP TABLE IF EXISTS gold.dim_date;

CREATE TABLE gold.dim_date AS
SELECT DISTINCT
    order_date::date AS date_key,
    EXTRACT(YEAR FROM order_date)::int AS year,
    EXTRACT(QUARTER FROM order_date)::int AS quarter,
    EXTRACT(MONTH FROM order_date)::int AS month,
    TRIM(TO_CHAR(order_date, 'Month')) AS month_name,
    EXTRACT(DAY FROM order_date)::int AS day,
    EXTRACT(DOW FROM order_date)::int AS day_of_week,
    TRIM(TO_CHAR(order_date, 'Day')) AS day_name
FROM silver.clean_orders
WHERE order_date IS NOT NULL;




-- =========================
-- Fact table
-- =========================

DROP TABLE IF EXISTS gold.fact_orders CASCADE;

CREATE TABLE gold.fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_date,
    o.approved_date,
    o.delivered_date,

    oi.product_id,
    oi.seller_id,
    p.category,
    oi.price,
    oi.freight_value,

    pay.payment_type,
    pay.payment_installments,
    pay.payment_value

FROM silver.clean_orders o

LEFT JOIN silver.clean_order_items oi
ON o.order_id = oi.order_id

LEFT JOIN silver.final_products p
ON oi.product_id = p.product_id

LEFT JOIN silver.clean_order_payments pay
ON o.order_id = pay.order_id;



-- =========================
-- Indexes for performance
-- =========================

CREATE INDEX idx_fact_orders_order_id ON gold.fact_orders(order_id);
CREATE INDEX idx_fact_orders_customer_id ON gold.fact_orders(customer_id);
CREATE INDEX idx_fact_orders_product_id ON gold.fact_orders(product_id);
CREATE INDEX idx_fact_orders_seller_id ON gold.fact_orders(seller_id);

CREATE INDEX idx_dim_customers_id ON gold.dim_customers(customer_id);
CREATE INDEX idx_dim_products_id ON gold.dim_products(product_id);
CREATE INDEX idx_dim_sellers_id ON gold.dim_sellers(seller_id);
CREATE INDEX idx_dim_date_key ON gold.dim_date(date_key);