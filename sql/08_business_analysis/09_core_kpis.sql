-- CORE BUSINESS KPIs
-- Delivered GMV proxy is SUM(item price) for delivered orders.
-- It is not profit or accounting revenue. Freight is separate.

SELECT
 COUNT(DISTINCT fo.order_id) FILTER (WHERE fo.order_status='delivered') delivered_orders,
 SUM(fi.price) FILTER (WHERE fo.order_status='delivered') delivered_gmv_proxy,
 SUM(fi.freight_value) FILTER (WHERE fo.order_status='delivered') delivered_freight_value,
 COUNT(*) FILTER (WHERE fo.order_status='delivered') delivered_item_rows
FROM analytics.fact_orders fo
LEFT JOIN analytics.fact_order_items fi ON fi.order_sk=fo.order_sk;

SELECT
 COUNT(*) total_orders,
 COUNT(*) FILTER (WHERE order_status='delivered') delivered_orders,
 COUNT(*) FILTER (WHERE order_status='canceled') canceled_orders,
 COUNT(*) FILTER (WHERE order_status='unavailable') unavailable_orders,
 ROUND(100.0*COUNT(*) FILTER (WHERE order_status='delivered')/NULLIF(COUNT(*),0),2) delivered_rate_pct
FROM analytics.fact_orders;

SELECT
 ROUND(100.0*COUNT(*) FILTER (WHERE is_on_time AND delivery_date_sk IS NOT NULL)
 / NULLIF(COUNT(*) FILTER (WHERE is_delivered AND delivery_date_sk IS NOT NULL
                             AND estimated_delivery_date_sk IS NOT NULL),0),2) on_time_rate_pct,
 ROUND(AVG(delivery_days) FILTER (WHERE is_delivered)::numeric,2) avg_delivery_days,
 ROUND(AVG(delivery_delay_days) FILTER (WHERE is_delivered)::numeric,2) avg_delivery_delay_days
FROM analytics.fact_orders;

SELECT SUM(payment_value) total_payment_value,
       COUNT(*) payment_records
FROM analytics.fact_payments;

SELECT ROUND(AVG(review_score)::numeric,2) average_review_score,
       COUNT(*) total_reviews
FROM analytics.fact_reviews;

SELECT COUNT(*) items_sold FROM analytics.fact_order_items;
