-- READ-ONLY RAW DATA PROFILING / INTEGRITY CHECKS

-- Null profile for important source columns
SELECT 'customers.customer_id' field, COUNT(*) FILTER (WHERE customer_id IS NULL) nulls FROM raw.olist_customers
UNION ALL SELECT 'orders.order_id', COUNT(*) FILTER (WHERE order_id IS NULL) FROM raw.olist_orders
UNION ALL SELECT 'order_items.order_id', COUNT(*) FILTER (WHERE order_id IS NULL) FROM raw.olist_order_items
UNION ALL SELECT 'products.product_id', COUNT(*) FILTER (WHERE product_id IS NULL) FROM raw.olist_products
UNION ALL SELECT 'sellers.seller_id', COUNT(*) FILTER (WHERE seller_id IS NULL) FROM raw.olist_sellers;

-- Duplicate order identifiers
SELECT order_id, COUNT(*) occurrences
FROM raw.olist_orders GROUP BY order_id HAVING COUNT(*) > 1;

-- Duplicate item composite keys
SELECT order_id, order_item_id, COUNT(*) occurrences
FROM raw.olist_order_items
GROUP BY order_id, order_item_id HAVING COUNT(*) > 1;

-- Duplicate payment composite keys
SELECT order_id, payment_sequential, COUNT(*) occurrences
FROM raw.olist_order_payments
GROUP BY order_id, payment_sequential HAVING COUNT(*) > 1;

-- Repeated review IDs (do not assume review_id is unique)
SELECT review_id, COUNT(*) occurrences, COUNT(DISTINCT order_id) affected_orders
FROM raw.olist_order_reviews
GROUP BY review_id HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Orphan references
SELECT COUNT(*) orphan_order_customer_rows
FROM raw.olist_orders o LEFT JOIN raw.olist_customers c USING(customer_id)
WHERE c.customer_id IS NULL;

SELECT
 COUNT(*) FILTER (WHERE o.order_id IS NULL) orphan_item_order_rows,
 COUNT(*) FILTER (WHERE p.product_id IS NULL) missing_product_rows,
 COUNT(*) FILTER (WHERE s.seller_id IS NULL) missing_seller_rows
FROM raw.olist_order_items i
LEFT JOIN raw.olist_orders o USING(order_id)
LEFT JOIN raw.olist_products p USING(product_id)
LEFT JOIN raw.olist_sellers s USING(seller_id);

-- Orders without item rows
SELECT COUNT(*) orders_without_items
FROM raw.olist_orders o LEFT JOIN raw.olist_order_items i USING(order_id)
WHERE i.order_id IS NULL;

-- Product completeness
SELECT
 COUNT(*) total_products,
 COUNT(*) FILTER (WHERE product_category_name IS NULL) missing_category,
 COUNT(*) FILTER (WHERE product_weight_g IS NULL) missing_weight,
 COUNT(*) FILTER (WHERE product_length_cm IS NULL) missing_length,
 COUNT(*) FILTER (WHERE product_height_cm IS NULL) missing_height,
 COUNT(*) FILTER (WHERE product_width_cm IS NULL) missing_width
FROM raw.olist_products;

-- Geolocation exact duplicate rows beyond first
SELECT COUNT(*) duplicate_rows_beyond_first
FROM (
 SELECT ROW_NUMBER() OVER (
  PARTITION BY geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
               geolocation_city, geolocation_state
 ) rn
 FROM raw.olist_geolocation
) d WHERE rn > 1;

-- Order lifecycle anomalies (flag only; do not modify raw)
SELECT
 COUNT(*) FILTER (WHERE order_approved_at < order_purchase_timestamp) approval_before_purchase,
 COUNT(*) FILTER (WHERE order_delivered_carrier_date < order_approved_at) carrier_before_approval,
 COUNT(*) FILTER (WHERE order_delivered_customer_date < order_delivered_carrier_date) delivery_before_carrier,
 COUNT(*) FILTER (WHERE order_status='delivered' AND order_delivered_customer_date IS NULL) delivered_missing_actual_date
FROM raw.olist_orders;
