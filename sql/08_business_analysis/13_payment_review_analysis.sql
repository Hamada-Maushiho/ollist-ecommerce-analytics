-- PAYMENT METHOD ANALYSIS
SELECT pt.payment_type,COUNT(*) payment_records,
       SUM(p.payment_value) total_payment_value
FROM analytics.fact_payments p
JOIN analytics.dim_payment_type pt ON pt.payment_type_sk=p.payment_type_sk
GROUP BY pt.payment_type ORDER BY total_payment_value DESC;

SELECT pt.payment_type,p.payment_installments,
       COUNT(*) payment_records,SUM(p.payment_value) payment_value
FROM analytics.fact_payments p
JOIN analytics.dim_payment_type pt ON pt.payment_type_sk=p.payment_type_sk
GROUP BY pt.payment_type,p.payment_installments
ORDER BY pt.payment_type,p.payment_installments;

-- REVIEW SCORE DISTRIBUTION
SELECT review_score,COUNT(*) review_count
FROM analytics.fact_reviews
GROUP BY review_score ORDER BY review_score;

-- Monthly review trend; review date role is explicit.
SELECT d.year_number,d.month_number,
       COUNT(*) total_reviews,ROUND(AVG(r.review_score)::numeric,2) avg_review_score
FROM analytics.fact_reviews r
JOIN analytics.dim_date d ON d.date_sk=r.review_date_sk
GROUP BY d.year_number,d.month_number
ORDER BY d.year_number,d.month_number;
