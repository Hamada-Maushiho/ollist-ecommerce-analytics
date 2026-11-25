-- CUSTOMER ANALYSIS: use customer_unique_id for person-level identity.
WITH customer_order_counts AS (
 SELECT c.customer_unique_id,COUNT(DISTINCT o.order_id) delivered_order_count
 FROM analytics.fact_orders o
 JOIN analytics.dim_customers c ON c.customer_sk=o.customer_sk
 WHERE o.order_status='delivered'
 GROUP BY c.customer_unique_id
)
SELECT CASE
 WHEN delivered_order_count=1 THEN 'One-time'
 WHEN delivered_order_count=2 THEN 'Repeat'
 WHEN delivered_order_count BETWEEN 3 AND 5 THEN 'Loyal'
 ELSE 'High frequency' END customer_segment,
 COUNT(*) customers
FROM customer_order_counts
GROUP BY 1 ORDER BY customers DESC;

-- Customer distribution by state
SELECT c.state,COUNT(DISTINCT c.customer_unique_id) unique_customers,
       COUNT(DISTINCT o.order_id) delivered_orders
FROM analytics.fact_orders o
JOIN analytics.dim_customers c ON c.customer_sk=o.customer_sk
WHERE o.order_status='delivered'
GROUP BY c.state ORDER BY unique_customers DESC;

-- Monthly first delivered purchase
WITH first_purchase AS (
 SELECT c.customer_unique_id,
        MIN(d.full_date) first_purchase_date
 FROM analytics.fact_orders o
 JOIN analytics.dim_customers c ON c.customer_sk=o.customer_sk
 JOIN analytics.dim_date d ON d.date_sk=o.purchase_date_sk
 WHERE o.order_status='delivered'
 GROUP BY c.customer_unique_id
)
SELECT DATE_TRUNC('month',first_purchase_date)::date acquisition_month,
       COUNT(*) acquired_customers
FROM first_purchase
GROUP BY 1 ORDER BY 1;
