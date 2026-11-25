-- ANALYTICS MODEL VALIDATION
SELECT 'dim_customers' table_name, COUNT(*) row_count FROM analytics.dim_customers
UNION ALL SELECT 'dim_products',COUNT(*) FROM analytics.dim_products
UNION ALL SELECT 'dim_sellers',COUNT(*) FROM analytics.dim_sellers
UNION ALL SELECT 'dim_geography',COUNT(*) FROM analytics.dim_geography
UNION ALL SELECT 'dim_date',COUNT(*) FROM analytics.dim_date
UNION ALL SELECT 'dim_payment_type',COUNT(*) FROM analytics.dim_payment_type
UNION ALL SELECT 'fact_orders',COUNT(*) FROM analytics.fact_orders
UNION ALL SELECT 'fact_order_items',COUNT(*) FROM analytics.fact_order_items
UNION ALL SELECT 'fact_payments',COUNT(*) FROM analytics.fact_payments
UNION ALL SELECT 'fact_reviews',COUNT(*) FROM analytics.fact_reviews
ORDER BY table_name;

-- Missing dimension key coverage
SELECT
 COUNT(*) FILTER (WHERE customer_sk IS NULL) orders_without_customer_dimension
FROM analytics.fact_orders;

SELECT
 COUNT(*) FILTER (WHERE product_sk IS NULL) items_without_product_dimension,
 COUNT(*) FILTER (WHERE seller_sk IS NULL) items_without_seller_dimension,
 COUNT(*) FILTER (WHERE order_sk IS NULL) items_without_order_fact
FROM analytics.fact_order_items;

SELECT
 COUNT(*) FILTER (WHERE payment_type_sk IS NULL) payments_without_type_dimension,
 COUNT(*) FILTER (WHERE order_sk IS NULL) payments_without_order_fact
FROM analytics.fact_payments;

SELECT
 COUNT(*) FILTER (WHERE order_sk IS NULL) reviews_without_order_fact
FROM analytics.fact_reviews;

-- Date-key coverage
SELECT
 COUNT(*) FILTER (WHERE d.date_sk IS NULL) missing_purchase_date_keys
FROM analytics.fact_orders f
LEFT JOIN analytics.dim_date d ON d.date_sk=f.purchase_date_sk;

-- Confirm fact grains
SELECT order_id, COUNT(*) FROM analytics.fact_orders
GROUP BY order_id HAVING COUNT(*)>1;

SELECT order_id,order_item_id,COUNT(*) FROM analytics.fact_order_items
GROUP BY order_id,order_item_id HAVING COUNT(*)>1;
