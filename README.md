# E-Commerce_Customer_Analytics_Project

## Introduction
This project focuses on the **Olist Brazilian E-Commerce Public Dataset** to understand patterns in payments, orders, product categories, customers, sellers, and deliveries. The goal is to evaluate business performance using SQL, Python, and Power BI and to highlight key factors driving revenue and customer satisfaction. 
Analyzing this data provides actionable insights into customer behavior, sales performance, delivery efficiency, and overall business growth.

## Dataset
* **Source:** Kaggle – [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Size:** 9 CSV files (\~500k+ rows across different tables)
* **Imported:** CSV files were imported into **MySQL** using `sqlalchemy` and `sqlconnector` from Python.
* **Tables include:** Orders, Customers, Sellers, Payments, Order Items, Products, Reviews, Geolocation, and Category Translation.

## Tools Used
* **MySQL:** SQL queries for data cleaning, joining, aggregation, and advanced analytics
* **Python:** (Pandas, Matplotlib, Seaborn) for data processing, Exploratory Data Analysis (EDA), outlier detection, and regression.
* **Power BI:** For building interactive Dashboards, DAX measures, and mobile + desktop layouts.

## Data Analysis

### SQL Analysis

**Methods Used:**
* Joins, Aggregations, Filtering, Subqueries, Window Functions, UNION, CTEs

**Key Analyses:**
* Distribution of payments & order values
* Payment mode by average payment value
* Top 10 customers, sellers, and product categories by revenue and sales
* Orders by month, year, and state
* New vs Returning customers (yearly)
* Product categories by revenue, reviews, and delivery times
* Delivery delays by state
* Correlation between delivery days & review scores
* Customer churn rate and revenue rank by state
* Popular Product Category by Quarter

### Python Analysis

**Libraries Used:** Pandas, Matplotlib, Seaborn

**Methods:** 
* Imported, Merged datasets, bar plots, boxplots, line plots, regression plots, scatter plots, pie charts, and descriptive statistics.

**Key Analyses:**
* Top 10 products & states by revenue
* Order status distribution
* Outlier detection (payment, freight cost, delivery time) using percentiles
* Monthly revenue trend visualization
* Product categories by average review score
* Regression: delivery time vs review score
* Correlation: product weight vs freight cost (0.61 correlation)
* Pie chart of delivery time distribution

### Power BI Analysis

**Link:**
**Power BI Dashboard: *[Olist_Business_Performance_Dashboard](https://drive.google.com/drive/folders/1FZOpgvmjpT_275h3RbOeugZj5rIXuOU0?usp=sharing)***

**Methods Used:**
* Removed unnecessary columns
* Created calculated columns and DAX measures
* Used slicers and interactive visuals
* Built both desktop and mobile dashboards

**Key Analyses:**
* Delivery status distribution
* Top 10 states and products by revenue
* Orders by review score
* Revenue & orders by quarter
* Customers by state
* Average review scores vs delivery times

## Key Insights

* **Payment Trends:** Credit cards dominate payment mode, generating the highest revenue.
* **Geographic Insights:** States **SP (São Paulo)** and **RJ (Rio de Janeiro)** lead in revenue and customer base.
* **Customer Growth:** In 2018, \~52k new customers joined (higher than 2017). Orders reached \~57k with **8.8M revenue**, up from **6.5M in 2017**.
* **Top Products:** *Bed Bath Table* and *Health Beauty* categories lead sales (11k+ orders; \~1.5M revenue each). They also received both high (>7k) and low (<2.5k) review scores, showing mixed customer satisfaction.
* **Delivery Performance:**
  * \~90% of deliveries were on time.
  * Most delays occurred in **SP**, where high order volume caused bottlenecks (\~2k delayed orders).
  * Average delivery: **10–15 days**.
  * 75% of deliveries completed within 15 days.
* **Cost Insights:**
  * 95% of orders had freight costs between **13–45**.
  * Only 10% of orders exceeded **500** in payment value, showing most products are affordable.
* **Customer Behavior:** High churn (\~97%) indicates most customers purchase only once.
* **Correlations:**
  * Longer delivery times → lower review scores.
  * Higher product weight → higher freight cost (correlation = 0.61).

## Recommendations

1. **Delivery Optimization:**
   * Improve logistics in **São Paulo** (e.g., partnerships with local couriers or micro-warehousing) to reduce delays.
2. **Customer Retention:**
   * Implement loyalty programs, targeted promotions, and personalized offers to reduce churn and encourage repeat purchases.
3. **Product Category Focus:**
   * Prioritize marketing of *Bed Bath Table* and *Health Beauty* while improving product quality to reduce negative reviews.
4. **Review Management:**
   * Address customer feedback proactively, especially related to delivery delays, to improve review scores.
5. **Freight Cost Strategy:**
   * Offer bundled shipping or free delivery thresholds to offset higher freight costs for heavier items.

## Conclusion
This project highlights the business performance of Olist using SQL, Python, and Power BI. The analyses revealed growth opportunities in delivery efficiency, customer retention, and product category strategies. While Olist achieved strong sales growth in 2018, challenges remain in managing delivery delays and customer churn. By focusing on logistics, customer loyalty, and product satisfaction, Olist can further strengthen its market position in Brazil’s competitive e-commerce industry.
