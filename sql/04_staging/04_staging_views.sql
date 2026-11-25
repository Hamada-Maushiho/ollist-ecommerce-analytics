-- RECONSTRUCTED STAGING LAYER
-- These are clean analytical views; raw source tables remain unchanged.
-- Eleven views are created to separate entity standardization and child-table aggregates.

CREATE OR REPLACE VIEW staging.stg_customers AS
SELECT customer_id, customer_unique_id,
       LPAD(customer_zip_code_prefix,5,'0') customer_zip_code_prefix,
       INITCAP(TRIM(customer_city)) customer_city,
       UPPER(TRIM(customer_state)) customer_state
FROM raw.olist_customers;

CREATE OR REPLACE VIEW staging.stg_orders AS
SELECT order_id, customer_id, LOWER(TRIM(order_status)) order_status,
       order_purchase_timestamp, order_approved_at,
       order_delivered_carrier_date, order_delivered_customer_date,
       order_estimated_delivery_date,
       (order_status='delivered') is_delivered,
       CASE WHEN order_status='delivered'
              AND order_delivered_customer_date IS NOT NULL
              AND order_estimated_delivery_date IS NOT NULL
            THEN order_delivered_customer_date <= order_estimated_delivery_date
            ELSE FALSE END is_on_time,
       CASE WHEN order_delivered_customer_date IS NOT NULL
                 AND order_purchase_timestamp IS NOT NULL
            THEN EXTRACT(EPOCH FROM (order_delivered_customer_date-order_purchase_timestamp))/86400.0
       END delivery_days,
       CASE WHEN order_delivered_customer_date IS NOT NULL
                 AND order_estimated_delivery_date IS NOT NULL
            THEN EXTRACT(EPOCH FROM (order_delivered_customer_date-order_estimated_delivery_date))/86400.0
       END delivery_delay_days,
       (order_approved_at < order_purchase_timestamp) approval_before_purchase,
       (order_delivered_carrier_date < order_approved_at) carrier_before_approval,
       (order_delivered_customer_date < order_delivered_carrier_date) delivery_before_carrier
FROM raw.olist_orders;

CREATE OR REPLACE VIEW staging.stg_order_items AS
SELECT order_id, order_item_id, product_id, seller_id, shipping_limit_date,
       price, freight_value, price + freight_value item_total_value
FROM raw.olist_order_items;

CREATE OR REPLACE VIEW staging.stg_order_payments AS
SELECT order_id, payment_sequential, LOWER(TRIM(payment_type)) payment_type,
       payment_installments, payment_value
FROM raw.olist_order_payments;

CREATE OR REPLACE VIEW staging.stg_order_reviews AS
SELECT review_id, order_id, review_score,
       NULLIF(TRIM(review_comment_title),'') review_comment_title,
       NULLIF(TRIM(review_comment_message),'') review_comment_message,
       review_creation_date, review_answer_timestamp,
       (review_answer_timestamp < review_creation_date) review_timing_anomaly
FROM raw.olist_order_reviews;

CREATE OR REPLACE VIEW staging.stg_products AS
SELECT p.product_id, p.product_category_name,
       COALESCE(t.product_category_name_english,p.product_category_name,'Unknown / Unclassified')
         product_category_english,
       p.product_name_lenght, p.product_description_lenght, p.product_photos_qty,
       p.product_weight_g, p.product_length_cm, p.product_height_cm, p.product_width_cm
FROM raw.olist_products p
LEFT JOIN raw.product_category_translation t
  ON p.product_category_name=t.product_category_name;

CREATE OR REPLACE VIEW staging.stg_sellers AS
SELECT seller_id, LPAD(seller_zip_code_prefix,5,'0') seller_zip_code_prefix,
       INITCAP(TRIM(seller_city)) seller_city, UPPER(TRIM(seller_state)) state
FROM raw.olist_sellers;

CREATE OR REPLACE VIEW staging.stg_geolocation_deduplicated AS
SELECT DISTINCT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state
FROM raw.olist_geolocation;

CREATE OR REPLACE VIEW staging.stg_geography_zip AS
SELECT LPAD(geolocation_zip_code_prefix,5,'0') zip_code_prefix,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_lat) latitude,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY geolocation_lng) longitude,
       MODE() WITHIN GROUP (ORDER BY geolocation_city) city,
       MODE() WITHIN GROUP (ORDER BY geolocation_state) state
FROM staging.stg_geolocation_deduplicated
GROUP BY LPAD(geolocation_zip_code_prefix,5,'0');

CREATE OR REPLACE VIEW staging.stg_order_item_totals AS
SELECT order_id, COUNT(*) item_count, SUM(price) item_price_total,
       SUM(freight_value) freight_total, SUM(item_total_value) item_plus_freight_total
FROM staging.stg_order_items GROUP BY order_id;

CREATE OR REPLACE VIEW staging.stg_order_payment_totals AS
SELECT order_id, COUNT(*) payment_record_count, SUM(payment_value) payment_total
FROM staging.stg_order_payments GROUP BY order_id;
