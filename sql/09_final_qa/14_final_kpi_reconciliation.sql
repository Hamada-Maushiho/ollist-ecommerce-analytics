-- FINAL RECONCILIATION CHECKS
-- These queries compare core KPI outputs with known project checkpoints.
-- Re-run after any data refresh; do not hard-code expected results into source data.

-- Raw source row counts
SELECT
 (SELECT COUNT(*) FROM raw.olist_customers) customers,
 (SELECT COUNT(*) FROM raw.olist_orders) orders,
 (SELECT COUNT(*) FROM raw.olist_order_items) order_items,
 (SELECT COUNT(*) FROM raw.olist_order_payments) payments,
 (SELECT COUNT(*) FROM raw.olist_order_reviews) reviews,
 (SELECT COUNT(*) FROM raw.olist_products) products,
 (SELECT COUNT(*) FROM raw.olist_sellers) sellers,
 (SELECT COUNT(*) FROM raw.olist_geolocation) geolocation,
 (SELECT COUNT(*) FROM raw.product_category_translation) category_translation;

-- Delivered GMV / freight
SELECT SUM(i.price) delivered_gmv_proxy,
       SUM(i.freight_value) delivered_freight
FROM raw.olist_orders o
JOIN raw.olist_order_items i USING(order_id)
WHERE o.order_status='delivered';

-- Customer repeat purchase distribution
WITH x AS (
 SELECT c.customer_unique_id,COUNT(DISTINCT o.order_id) delivered_orders
 FROM raw.olist_orders o JOIN raw.olist_customers c USING(customer_id)
 WHERE o.order_status='delivered'
 GROUP BY c.customer_unique_id
)
SELECT COUNT(*) unique_customers,
       COUNT(*) FILTER (WHERE delivered_orders=1) one_time,
       COUNT(*) FILTER (WHERE delivered_orders=2) repeat,
       COUNT(*) FILTER (WHERE delivered_orders BETWEEN 3 AND 5) loyal,
       COUNT(*) FILTER (WHERE delivered_orders>5) high_frequency
FROM x;

-- Payment totals by method
SELECT payment_type,SUM(payment_value) payment_value
FROM raw.olist_order_payments GROUP BY payment_type
ORDER BY payment_value DESC;

-- Review average and distribution
SELECT AVG(review_score) average_review_score,COUNT(*) review_rows
FROM raw.olist_order_reviews;
SELECT review_score,COUNT(*) review_rows
FROM raw.olist_order_reviews GROUP BY review_score ORDER BY review_score;
