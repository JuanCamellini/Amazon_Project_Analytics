# 🛒 Amazon Market Analysis

## 📌 Project Overview

This project focuses on analyzing top-performing products across four major Amazon categories:

* Electronics
* Beauty & Personal Care
* Home & Kitchen
* Sports & Outdoors

Using data extracted via the Rainforest API, the goal is to simulate a real-world **market analysis workflow**, transforming raw e-commerce data into actionable insights.

> The project follows an end-to-end data pipeline: from data extraction → processing → analysis → SQL modeling → BI visualization.

---

## 🎯 Objective

Identify patterns behind top-performing Amazon products by analyzing:

* Sales distribution
* Pricing strategies
* Review behavior
* Discount usage
* Category-level performance

> This project is designed to demonstrate real-world data analyst skills, including data extraction, transformation, analysis, and visualization.

---

## 📡 Data Source

Data was collected using the **Rainforest API**, a scraping service for Amazon product data.

### 🔹 Datasets Created

**1. search_clean (market-level data)**
Contains large-scale product data scraped across categories and pages.

* ~932 products collected
* Includes:

  * price
  * rating
  * review count
  * sales approximation
  * discount info
  * search position

---

**2. products_top (product-level enrichment)**
Focuses on top-performing products with deeper attributes.

* brand
* subcategory
* seller information
* Best Seller Rank (BSR)
* engagement metrics

---

## ⚙️ Data Pipeline

The project follows a structured data workflow:

```text
API (Rainforest) → JSON → Parsing → Structured Dataset → EDA → SQL → Power BI
```

### 🔹 Notebook Flow

* **01_api_search.ipynb** → Extracts product data across categories and pages
* **02_api_product.ipynb** → Enriches top products with detailed data
* **03_parse_search.ipynb** → Parses raw JSON into structured dataset
* **04_parse_product.ipynb** → Processes enriched product data
* **05_eda.ipynb** → Exploratory Data Analysis and insights

> A previous Kaggle-based approach was discarded due to non-representative regional data, reinforcing the use of real-time scraping.

---

# 📊 Key Insights

### 🛒 Sales Distribution

* Most products sell between **50–300 units/month**
* A smaller group reaches **high-volume sales (1K+)**
* The distribution follows a **long-tail pattern**

> Success is highly concentrated — most products compete in low-volume tiers.

---

### 📦 Category Performance

* **Beauty & Personal Care dominates total sales (~60%)**
* Requires fewer discounts to generate demand
* **Sports & Outdoors shows the weakest performance**

> Not all categories convert demand equally — Beauty stands out in efficiency.

---

### ⭐ Ratings & Reviews

* Average rating is highly consistent (~4.4–4.5 across all categories)
* Ratings are heavily skewed toward high values
* Beauty leads in total review volume (~10K avg)

> Ratings are not a strong differentiator between products.

---

### 💸 Discount Strategy

* Around **50% of products use discounts**
* Beauty differs significantly:

  * ~75% without discounts
  * ~25% with discounts

> Strong categories rely less on promotions and more on organic demand.

---

### 💰 Pricing Behavior

* **Electronics is a clear outlier**

  * Median price: ~$80
  * Range up to $1000+
* Other categories:

  * Median: $15–20
  * Low variability

> Pricing strongly influences review behavior and purchase decisions.

---

### 📢 Organic vs Sponsored

* ~80% of products rank organically
* ~20% are sponsored

> Organic visibility dominates, but this reflects a dynamic snapshot.

---

## 🗄️ SQL Data Layer

To support advanced analysis and BI integration, a structured SQL layer was implemented.

### 📌 Schema Design

* Creation of relational tables for:

  * search-level data
  * product-level enrichment

---

### 📊 Analytical Queries

#### 🔹 Search Position vs Sales

* Grouped products using `CASE WHEN`
* Compared performance by ranking position

> Products outside top positions can still outperform due to visibility dynamics.

---

#### 🔹 Products Above Category Average

* Used **JOIN + aggregated subquery**
* Identified products exceeding category benchmarks

> Helps detect high-performing outliers.

---

#### 🔹 Top Products per Category

* Applied **window functions (`RANK() OVER PARTITION BY`)**
* Extracted top 10 products per category

> Enables structured comparison of category leaders.

---

### 🧱 Data Modeling

* ~7 SQL views created
* Optimized for BI consumption
* Acts as a semantic layer for Power BI

---

## 📊 Power BI Dashboard

The final stage of the project includes an interactive Power BI dashboard.

### 🔹 Pages

* **Market Analysis** → category-level trends and KPIs
* **Category Analysis** → deeper breakdown per category
* **Top Products** → top-performing products comparison
* **Product Detail (Drill-through)** → detailed product-level insights

### 🔹 Features

* Interactive filters
* Drill-through navigation
* KPI cards
* Dynamic visualizations

---

## 🧰 Tech Stack

* Python
* Pandas
* NumPy
* Matplotlib / Seaborn
* Requests
* SQL
* Power BI

---

## 🚀 Future Improvements

* Automate data extraction pipeline
* Expand dataset size
* Integrate real-time dashboards
* Apply predictive modeling (sales forecasting)

---

## 📎 Repository Structure

```text
amazon-project/
│
├── notebooks/
├── sql/
├── powerbi/
├── images/
├── requirements.txt
└── README.md
```

---

## 💬 Final Note

This project demonstrates an end-to-end data analysis workflow, combining:

* Data extraction via API
* Data processing and transformation
* Exploratory analysis
* SQL-based modeling
* Business intelligence visualization

> Designed to reflect real-world data analyst responsibilities and decision-making processes.
