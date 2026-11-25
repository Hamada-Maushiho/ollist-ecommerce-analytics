-- OLIST E-COMMERCE ANALYTICS | PHASE 03.1
-- Source-recovered schema foundation. Safe to rerun.
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS raw.olist_customers (
 customer_id TEXT, customer_unique_id TEXT,
 customer_zip_code_prefix VARCHAR(5), customer_city TEXT, customer_state CHAR(2)
);
CREATE TABLE IF NOT EXISTS raw.olist_orders (
 order_id TEXT, customer_id TEXT, order_status TEXT,
 order_purchase_timestamp TIMESTAMP, order_approved_at TIMESTAMP,
 order_delivered_carrier_date TIMESTAMP, order_delivered_customer_date TIMESTAMP,
 order_estimated_delivery_date TIMESTAMP
);
CREATE TABLE IF NOT EXISTS raw.olist_order_items (
 order_id TEXT, order_item_id INTEGER, product_id TEXT, seller_id TEXT,
 shipping_limit_date TIMESTAMP, price NUMERIC(12,2), freight_value NUMERIC(12,2)
);
CREATE TABLE IF NOT EXISTS raw.olist_order_payments (
 order_id TEXT, payment_sequential INTEGER, payment_type TEXT,
 payment_installments INTEGER, payment_value NUMERIC(12,2)
);
CREATE TABLE IF NOT EXISTS raw.olist_order_reviews (
 review_id TEXT, order_id TEXT, review_score SMALLINT,
 review_comment_title TEXT, review_comment_message TEXT,
 review_creation_date TIMESTAMP, review_answer_timestamp TIMESTAMP
);
CREATE TABLE IF NOT EXISTS raw.olist_products (
 product_id TEXT, product_category_name TEXT,
 product_name_lenght INTEGER, product_description_lenght INTEGER,
 product_photos_qty INTEGER, product_weight_g NUMERIC(12,3),
 product_length_cm NUMERIC(12,3), product_height_cm NUMERIC(12,3),
 product_width_cm NUMERIC(12,3)
);
CREATE TABLE IF NOT EXISTS raw.olist_sellers (
 seller_id TEXT, seller_zip_code_prefix VARCHAR(5),
 seller_city TEXT, seller_state CHAR(2)
);
CREATE TABLE IF NOT EXISTS raw.olist_geolocation (
 geolocation_zip_code_prefix VARCHAR(5), geolocation_lat NUMERIC(12,8),
 geolocation_lng NUMERIC(12,8), geolocation_city TEXT, geolocation_state CHAR(2)
);
CREATE TABLE IF NOT EXISTS raw.product_category_translation (
 product_category_name TEXT, product_category_name_english TEXT
);

COMMENT ON TABLE raw.olist_customers IS 'Source grain: one row per customer_id; use customer_unique_id for person-level analysis.';
COMMENT ON TABLE raw.olist_orders IS 'Source grain: one row per order_id.';
COMMENT ON TABLE raw.olist_order_items IS 'Source grain: one row per (order_id, order_item_id).';
COMMENT ON TABLE raw.olist_order_payments IS 'Source grain: one row per (order_id, payment_sequential).';
COMMENT ON TABLE raw.olist_order_reviews IS 'Source review rows; review_id is not assumed unique.';
COMMENT ON TABLE raw.olist_geolocation IS 'Raw geographic observations; ZIP prefix can map to multiple coordinates.';

CREATE INDEX IF NOT EXISTS idx_raw_customers_unique ON raw.olist_customers(customer_unique_id);
CREATE INDEX IF NOT EXISTS idx_raw_customers_zip ON raw.olist_customers(customer_zip_code_prefix);
CREATE INDEX IF NOT EXISTS idx_raw_orders_customer ON raw.olist_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_raw_orders_purchase ON raw.olist_orders(order_purchase_timestamp);
CREATE INDEX IF NOT EXISTS idx_raw_orders_status ON raw.olist_orders(order_status);
CREATE INDEX IF NOT EXISTS idx_raw_items_order ON raw.olist_order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_raw_items_product ON raw.olist_order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_raw_items_seller ON raw.olist_order_items(seller_id);
CREATE INDEX IF NOT EXISTS idx_raw_payments_order ON raw.olist_order_payments(order_id);
CREATE INDEX IF NOT EXISTS idx_raw_reviews_order ON raw.olist_order_reviews(order_id);
CREATE INDEX IF NOT EXISTS idx_raw_products_category ON raw.olist_products(product_category_name);
CREATE INDEX IF NOT EXISTS idx_raw_geolocation_zip ON raw.olist_geolocation(geolocation_zip_code_prefix);
