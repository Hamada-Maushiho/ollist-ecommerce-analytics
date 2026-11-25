# Olist Ecommerce Analytics

An end-to-end e-commerce data analytics project using SQL, PostgreSQL, and Power BI to evaluate sales performance, customer behavior, product performance, seller activity, logistics, payment methods, and customer reviews.

## 1. Project Overview

This project analyzes the Olist Brazilian e-commerce dataset to understand business performance and identify insights that can support data-driven decisions.

The analysis covers the period **2016–2018** and follows an end-to-end workflow, from raw data preparation and data quality checks to analytical modeling, SQL analysis, and interactive dashboard development.

## 2. Business Objectives

The project aims to answer the following business questions:

- How is overall e-commerce sales performance?
- Which product categories and products generate the highest revenue?
- How are customers distributed across purchase-frequency segments?
- Which sellers contribute most to total sales?
- How well does the logistics process perform?
- Which payment methods are most commonly used?
- How do customers rate their shopping experience?

## 3. Tools & Technologies

| Tool             | Purpose                                                |
| ---------------- | ------------------------------------------------------ |
| PostgreSQL 18    | Data storage, transformation, and analysis             |
| pgAdmin 4        | Database management and SQL execution                  |
| SQL              | Data cleaning, validation, aggregation, and analysis   |
| Power BI Desktop | Data modeling, DAX measures, and dashboard development |
| Excel            | Supporting data inspection and validation              |

## 4. Dataset

The project uses the Olist Brazilian E-commerce dataset.

The raw dataset contains the following tables:

| Dataset                      |          Rows |
| ---------------------------- | ------------: |
| Customers                    |        99,441 |
| Orders                       |        99,441 |
| Order Items                  |       112,650 |
| Order Payments               |       103,886 |
| Order Reviews                |        99,224 |
| Products                     |        32,951 |
| Sellers                      |         3,095 |
| Geolocation                  |     1,000,163 |
| Product Category Translation |            71 |
| **Total**                    | **1,644,922** |

## 5. Data Preparation & Modeling

The project uses a structured data preparation workflow:

1. **Raw data ingestion** — imported the source datasets into PostgreSQL.
2. **Data quality assessment** — checked missing values, duplicate records, date inconsistencies, and reconciliation between orders, items, and payments.
3. **Staging layer** — created staging views to prepare and standardize data for analysis.
4. **Analytical modeling** — developed a dimensional model using fact and dimension tables.
5. **Power BI integration** — connected the analytical tables to Power BI for reporting and visualization.

### Data Model

The analytical schema consists of four fact tables and six dimension tables.

**Fact tables**

- `fact_orders`
- `fact_order_items`
- `fact_payments`
- `fact_reviews`

**Dimension tables**

- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_geography`
- `dim_date`
- `dim_payment_type`

Additional geography reference tables were prepared for customer and seller geographic analysis in Power BI.

## 6. Key Performance Indicators

The dashboard includes the following business metrics:

| KPI                     |          Result |
| ----------------------- | --------------: |
| Total Orders            |          99,441 |
| Delivered Orders        |          96,478 |
| Canceled Orders         |             625 |
| Unavailable Orders      |             609 |
| Delivered Rate          |          97.02% |
| On-Time Delivery Rate   |          93.22% |
| Delivered GMV           | R$13,221,498.11 |
| Delivered Freight Value |  R$2,198,275.64 |
| Total Payment Value     | R$16,008,872.12 |
| Items Sold              |         110,197 |
| Average Delivery Time   |      12.50 days |
| Average Delivery Delay  |     -11.88 days |
| Average Review Score    |        4.09 / 5 |

*Note: Delivered GMV and total payment value are different metrics and should not be interpreted as interchangeable.*

## 7. Key Business Findings

### Sales & Product Performance

- Health & Beauty generated the highest category GMV at **R$1,233,131.72**.
- Watches & Gifts ranked second with **R$1,166,176.98**.
- Bed Bath & Table ranked third with **R$1,023,434.76**.

### Customer Analytics

- The analysis identified **93,358 customers** with delivered orders.
- The majority were one-time customers: **90,557**.
- Repeat customers accounted for **2,754**, while loyal and high-frequency segments were considerably smaller.

### Payment Analytics

- Credit cards were the dominant payment method, with a payment value of **R$12,542,084.19**.
- Boleto was the second-largest payment method, totaling **R$2,869,361.27**.

### Logistics Performance

- The on-time delivery rate was **93.22%**.
- Average delivery time was **12.50 days**.
- Average delivery delay was **-11.88 days**, indicating that deliveries were, on average, completed before the estimated delivery date under the project's calculation.

### Customer Reviews

- The average review score was **4.09 out of 5**.
- The most frequent rating was 5, with **57,328 reviews**.

## 8. Power BI Dashboard

The interactive report contains five analytical pages:

1. **Executive Overview** — overall business performance and key KPIs.
2. **Sales & Product Performance** — revenue trends, top products, and product category performance.
3. **Customer Analytics** — customer segmentation, purchase frequency, geographic distribution, and acquisition trends.
4. **Seller & Logistics Performance** — seller contribution, seller distribution, and delivery performance.
5. **Payment & Review Analytics** — payment method distribution, installment behavior, and customer review analysis.

The report includes interactive filters to support exploration of the data.

## 9. Project Skills Demonstrated

- Relational database management
- SQL data cleaning and transformation
- Data quality assessment and validation
- Analytical data modeling and star schema design
- Business KPI development
- Data analysis and interpretation
- Power BI data modeling and DAX
- Interactive dashboard design
- Business insight communication

## 10. Conclusion

This project demonstrates an end-to-end data analytics workflow using a real-world e-commerce dataset. By combining SQL-based data preparation and analysis with Power BI visualization, the project provides a structured view of sales, customers, products, sellers, logistics, payments, and customer satisfaction.

The findings highlight strong delivery performance alongside opportunities to improve customer retention and better understand product and seller contributions.

---

**Project:** Olist Ecommerce Analytics
**Domain:** E-commerce
**Tools:** PostgreSQL, SQL, Power BI, Excel
**Dataset Period:** 2016–2018
