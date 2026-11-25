# Data Model

## Architecture

The project uses a layered PostgreSQL structure:

- `raw`: source-faithful Olist tables. Original records are preserved.
- `staging`: standardized and validated transformations.
- `analytics`: business-facing fact and dimension tables used by Power BI.

## Source tables

Nine source datasets are loaded:

`olist_customers`, `olist_orders`, `olist_order_items`, `olist_order_payments`, `olist_order_reviews`, `olist_products`, `olist_sellers`, `olist_geolocation`, and `product_category_translation`.

## Analytical model

The analytical schema contains four fact tables:

- `analytics.fact_orders`
- `analytics.fact_order_items`
- `analytics.fact_payments`
- `analytics.fact_reviews`

And six dimensions:

- `analytics.dim_customers`
- `analytics.dim_products`
- `analytics.dim_sellers`
- `analytics.dim_geography`
- `analytics.dim_date`
- `analytics.dim_payment_type`

Power BI also uses customer and seller geography reference tables to separate the two geographic roles.

## Grain and join safety

- Orders: one row per `order_id`.
- Order items: one row per `(order_id, order_item_id)`.
- Payments: one row per `(order_id, payment_sequential)`.
- Reviews: source review rows; `review_id` is not assumed unique.

Items, payments, and reviews can each contain multiple rows per order. Aggregate each child table to the intended grain before joining it to another child table. This avoids row multiplication and inflated totals.
