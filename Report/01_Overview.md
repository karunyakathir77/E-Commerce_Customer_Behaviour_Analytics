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
