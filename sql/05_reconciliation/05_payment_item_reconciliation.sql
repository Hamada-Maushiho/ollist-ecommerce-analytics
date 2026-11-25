-- Reconciliation at order grain. Aggregate each child table BEFORE joining.
CREATE OR REPLACE VIEW staging.vw_order_payment_reconciliation AS
WITH i AS (
 SELECT order_id, SUM(price + freight_value) item_plus_freight_total
 FROM staging.stg_order_items GROUP BY order_id
),
p AS (
 SELECT order_id, SUM(payment_value) payment_total
 FROM staging.stg_order_payments GROUP BY order_id
)
SELECT o.order_id, o.order_status, i.item_plus_freight_total, p.payment_total,
       CASE
        WHEN i.order_id IS NULL THEN 'MISSING_ITEMS'
        WHEN p.order_id IS NULL THEN 'MISSING_PAYMENT'
        WHEN ABS(i.item_plus_freight_total-p.payment_total)<=0.01 THEN 'MATCHED'
        ELSE 'MISMATCH'
       END reconciliation_status,
       CASE WHEN i.order_id IS NOT NULL AND p.order_id IS NOT NULL
            THEN p.payment_total-i.item_plus_freight_total END difference
FROM staging.stg_orders o
LEFT JOIN i USING(order_id)
LEFT JOIN p USING(order_id);

SELECT reconciliation_status, COUNT(*) order_count
FROM staging.vw_order_payment_reconciliation
GROUP BY reconciliation_status ORDER BY reconciliation_status;

-- Detail of mismatches only
SELECT *
FROM staging.vw_order_payment_reconciliation
WHERE reconciliation_status='MISMATCH'
ORDER BY ABS(difference) DESC;
