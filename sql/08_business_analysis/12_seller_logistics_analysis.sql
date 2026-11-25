-- SELLER PERFORMANCE
SELECT s.seller_id,s.state,
       SUM(i.price) delivered_gmv_proxy,COUNT(*) item_rows
FROM analytics.fact_order_items i
JOIN analytics.fact_orders o ON o.order_sk=i.order_sk
JOIN analytics.dim_sellers s ON s.seller_sk=i.seller_sk
WHERE o.order_status='delivered'
GROUP BY s.seller_id,s.state
ORDER BY delivered_gmv_proxy DESC
LIMIT 10;

SELECT s.state,COUNT(DISTINCT s.seller_id) sellers,
       SUM(i.price) delivered_gmv_proxy
FROM analytics.fact_order_items i
JOIN analytics.fact_orders o ON o.order_sk=i.order_sk
JOIN analytics.dim_sellers s ON s.seller_sk=i.seller_sk
WHERE o.order_status='delivered'
GROUP BY s.state ORDER BY delivered_gmv_proxy DESC;

-- Delivery performance by purchase month
SELECT d.year_number,d.month_number,
       COUNT(*) FILTER (WHERE o.is_delivered) delivered_orders,
       COUNT(*) FILTER (WHERE o.is_delivered AND o.is_on_time) on_time_orders,
       ROUND(AVG(o.delivery_days) FILTER (WHERE o.is_delivered)::numeric,2) avg_delivery_days,
       ROUND(AVG(o.delivery_delay_days) FILTER (WHERE o.is_delivered)::numeric,2) avg_delay_days
FROM analytics.fact_orders o
JOIN analytics.dim_date d ON d.date_sk=o.purchase_date_sk
GROUP BY d.year_number,d.month_number
ORDER BY d.year_number,d.month_number;

-- Delay distribution among delivered orders with both dates available
SELECT CASE
 WHEN delivery_delay_days < -15 THEN 'More than 15 days early'
 WHEN delivery_delay_days < 0 THEN '1–15 days early'
 WHEN delivery_delay_days = 0 THEN 'On estimated date'
 WHEN delivery_delay_days <= 7 THEN '1–7 days late'
 ELSE 'More than 7 days late' END delay_band,
 COUNT(*) orders
FROM analytics.fact_orders
WHERE is_delivered AND delivery_date_sk IS NOT NULL
  AND estimated_delivery_date_sk IS NOT NULL
GROUP BY 1 ORDER BY orders DESC;
