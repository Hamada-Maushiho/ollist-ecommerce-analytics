-- Import CSVs into the nine raw tables using pgAdmin Import/Export.
-- Keep raw CSVs unchanged. For ZIP prefixes, import as text to preserve leading zeros.
-- After import, verify these source counts.

SELECT 'olist_customers' table_name, COUNT(*) row_count FROM raw.olist_customers
UNION ALL SELECT 'olist_orders', COUNT(*) FROM raw.olist_orders
UNION ALL SELECT 'olist_order_items', COUNT(*) FROM raw.olist_order_items
UNION ALL SELECT 'olist_order_payments', COUNT(*) FROM raw.olist_order_payments
UNION ALL SELECT 'olist_order_reviews', COUNT(*) FROM raw.olist_order_reviews
UNION ALL SELECT 'olist_products', COUNT(*) FROM raw.olist_products
UNION ALL SELECT 'olist_sellers', COUNT(*) FROM raw.olist_sellers
UNION ALL SELECT 'olist_geolocation', COUNT(*) FROM raw.olist_geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM raw.product_category_translation
ORDER BY table_name;

-- Expected source row counts:
-- customers 99,441; orders 99,441; order_items 112,650
-- payments 103,886; reviews 99,224; products 32,951
-- sellers 3,095; geolocation 1,000,163; translation 71
