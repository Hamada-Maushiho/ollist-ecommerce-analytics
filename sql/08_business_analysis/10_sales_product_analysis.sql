-- SALES AND PRODUCT PERFORMANCE
-- Monthly delivered GMV
SELECT d.year_number,d.month_number,d.month_name,
       SUM(i.price) delivered_gmv_proxy,
       COUNT(DISTINCT o.order_id) delivered_orders
FROM analytics.fact_orders o
JOIN analytics.fact_order_items i ON i.order_sk=o.order_sk
JOIN analytics.dim_date d ON d.date_sk=o.purchase_date_sk
WHERE o.order_status='delivered'
GROUP BY d.year_number,d.month_number,d.month_name
ORDER BY d.year_number,d.month_number;

-- Top categories by delivered GMV
SELECT p.product_category_english,
       SUM(i.price) delivered_gmv_proxy,
       COUNT(*) items_sold
FROM analytics.fact_order_items i
JOIN analytics.fact_orders o ON o.order_sk=i.order_sk
JOIN analytics.dim_products p ON p.product_sk=i.product_sk
WHERE o.order_status='delivered'
GROUP BY p.product_category_english
ORDER BY delivered_gmv_proxy DESC;

-- Top products by delivered GMV
SELECT p.product_id,p.product_category_english,
       SUM(i.price) delivered_gmv_proxy,COUNT(*) units_sold
FROM analytics.fact_order_items i
JOIN analytics.fact_orders o ON o.order_sk=i.order_sk
JOIN analytics.dim_products p ON p.product_sk=i.product_sk
WHERE o.order_status='delivered'
GROUP BY p.product_id,p.product_category_english
ORDER BY delivered_gmv_proxy DESC
LIMIT 20;

-- Price distribution bands
SELECT CASE
 WHEN price < 50 THEN 'Under R$50'
 WHEN price < 100 THEN 'R$50–99'
 WHEN price < 250 THEN 'R$100–249'
 WHEN price < 500 THEN 'R$250–499'
 ELSE 'R$500+' END price_band,
 COUNT(*) item_rows, SUM(price) item_value
FROM analytics.fact_order_items
GROUP BY 1
ORDER BY MIN(price);
