-- Bronze layer: raw CSV load

CREATE TABLE IF NOT EXISTS bronze.raw_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

TRUNCATE TABLE bronze.raw_orders;

COPY bronze.raw_orders
FROM 'F:/Learning Project/Olist Data engineering/data/olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS bronze.raw_order_items (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);

TRUNCATE TABLE bronze.raw_order_items;

COPY bronze.raw_order_items
FROM 'F:/Learning Project/Olist Data engineering/data/olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS bronze.raw_customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

TRUNCATE TABLE bronze.raw_customers;

COPY bronze.raw_customers
FROM 'F:/Learning Project/Olist Data engineering/data/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS bronze.raw_products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_length TEXT,
    product_description_length TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);

TRUNCATE TABLE bronze.raw_products;

COPY bronze.raw_products
FROM 'F:/Learning Project/Olist Data engineering/data/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS bronze.raw_product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);

TRUNCATE TABLE bronze.raw_product_category_translation;

COPY bronze.raw_product_category_translation
FROM 'F:/Learning Project/Olist Data engineering/data/product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS bronze.raw_sellers (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

TRUNCATE TABLE bronze.raw_sellers;

COPY bronze.raw_sellers
FROM 'F:/Learning Project/Olist Data engineering/data/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS bronze.raw_order_payments (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT
);

TRUNCATE TABLE bronze.raw_order_payments;

COPY bronze.raw_order_payments
FROM 'F:/Learning Project/Olist Data engineering/data/olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;