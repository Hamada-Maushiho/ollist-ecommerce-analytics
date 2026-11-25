# Data Quality Report

The raw layer is preserved without destructive cleaning. Quality issues are flagged and handled in derived layers.

## Recorded audit observations

| Area | Observation | Handling |
|---|---|---|
| Orders | 99,441 order IDs; no duplicate order IDs observed in the recorded audit | Preserve order-level grain |
| Order items | No duplicate `(order_id, order_item_id)` pairs observed | Use composite key candidate |
| Payments | Multiple payment records per order are valid | Aggregate to order grain before joining |
| Reviews | Repeated `review_id` values were observed; 789 repeated ID groups were reported in an earlier audit | Do not use `review_id` alone as a primary key |
| Geolocation | 261,831 exact duplicate rows were reported | Deduplicate only in a derived analytical copy |
| Geolocation | ZIP prefixes can map to multiple coordinate pairs | Use a documented representative-coordinate method |
| Products | 610 missing product categories were reported | Preserve NULL in raw; label only in reporting layer |
| Category translation | Two categories were not translated | Preserve original Portuguese category when no translation exists |
| Orders | Missing lifecycle timestamps and chronology anomalies were observed | Preserve source timestamps and create flags |
| Order items | 383 rows with zero freight were reported | Preserve zero values |
| Reconciliation | 381 payment vs item-plus-freight mismatches were reported in a prior audit | Flag; do not force values to match |
| Orders/items | 775 orders without item rows were reported | Retain order headers and analyze separately |
| Payments | One delivered order without a payment row was reported | Flag for investigation; do not fabricate a payment |
