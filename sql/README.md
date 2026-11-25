# Olist SQL Scripts — Complete Reconstructed Set

This folder combines the recovered Phase 03.1 schema foundation with reconstructed scripts for the rest of the Olist project workflow.

## Important provenance note
- `01_setup/01_schema_and_raw_tables.sql` is based on the recovered original `phase03_postgresql_schema.sql`.
- The staging views, dimensional model, facts, and later analysis scripts are reconstructions based on recorded project schema, column names, validation checkpoints, and prior work summaries. They are not claimed to be byte-for-byte copies of the original historical scripts.
- Review all scripts against the current PostgreSQL database before running. In particular, the dimension/fact scripts use full refresh (`TRUNCATE`) and are intended for a fresh/rebuildable analytics schema, not a production database with dependent objects.
- The staging layer creates eleven views as a clean, reproducible implementation. Exact historical names of all eleven prior views were not recovered.

## Execution order
1. `01_setup/01_schema_and_raw_tables.sql`
2. Import the nine original CSVs into `raw` using pgAdmin.
3. `02_import/02_import_notes_and_row_counts.sql`
4. `03_data_quality/03_raw_profile_and_integrity.sql`
5. `04_staging/04_staging_views.sql`
6. `05_reconciliation/05_payment_item_reconciliation.sql`
7. `06_analytics_model/06_dimensions.sql`
8. `06_analytics_model/07_facts.sql`
9. `07_validation/08_analytics_row_counts_and_relationships.sql`
10. Run the business analysis scripts in `08_business_analysis/`
11. Run `09_final_qa/14_final_kpi_reconciliation.sql`

## Model names
Raw: `raw.olist_*`, `raw.product_category_translation`
Staging: `staging.stg_*`, `staging.vw_order_payment_reconciliation`
Analytics: `analytics.dim_*`, `analytics.fact_*`

## Project caveats
- Keep raw data immutable.
- `customer_unique_id` is the person-level customer key.
- `review_id` is not assumed unique.
- Aggregate payments and order items independently before joining at order grain.
- Delivered GMV proxy is sum of item price for delivered orders; it is not profit/accounting revenue.
- Freight is reported separately.
- ZIP prefix is not a unique geography coordinate; this reconstruction uses median coordinates and modal city/state as a documented representative lookup.
- The original project recorded separate `dim_customer_geography` and `dim_seller_geography` Power BI reference queries. Those are Power BI-side reference queries, not additional PostgreSQL source facts.
