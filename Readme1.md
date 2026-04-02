# 🚀 SQL Data Warehouse Project

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-blue?logo=microsoftsqlserver\&logoColor=white)
![T-SQL](https://img.shields.io/badge/Language-T--SQL-informational)
![Architecture](https://img.shields.io/badge/Architecture-Medallion%20\(Bronze%20%7C%20Silver%20%7C%20Gold\)-orange)
![Modeling](https://img.shields.io/badge/Data%20Model-Star%20Schema-success)
![Git](https://img.shields.io/badge/Version%20Control-Git-black?logo=git)
![GitHub](https://img.shields.io/badge/Repo-GitHub-181717?logo=github)

---

## 📌 Overview

This project demonstrates the end-to-end design and implementation of a modern **data warehouse** using SQL Server. It follows the **Medallion Architecture (Bronze → Silver → Gold)** to transform raw data into clean, structured, and analytics-ready datasets.

The solution simulates a real-world retail environment by integrating data from multiple source systems (CRM & ERP), applying transformations, and delivering a business-ready data model for reporting and insights.

---

## 🏗️ Architecture

The data warehouse is structured into three layers:

### 🥉 Bronze Layer (Raw Data)

* Ingests raw data from source systems (CRM, ERP)
* Minimal transformation
* Stored as-is for traceability

### 🥈 Silver Layer (Cleaned Data)

* Data cleaning and standardization
* Handling missing and inconsistent values
* Data validation and quality checks

### 🥇 Gold Layer (Business Layer)

* Optimized for analytics and reporting
* Star schema implementation
* Aggregated and business-ready datasets

---

## 🔄 Data Flow

* Data is extracted from CRM and ERP systems
* Loaded into Bronze layer tables
* Transformed and validated in Silver layer
* Modeled into fact and dimension tables in Gold layer

---

## 🔗 Data Integration

This project integrates multiple datasets:

* **CRM system** → Customer and sales data
* **ERP system** → Product and location data

These datasets are joined and transformed to produce a unified analytical model.

---

## 🧱 Data Model (Star Schema)

The Gold layer is designed using a star schema:

### Fact Table

* `gold.fact_sales` → Stores transactional sales data

### Dimension Tables

* `gold.dim_customers` → Customer information
* `gold.dim_products` → Product details

This structure enables efficient querying and reporting.

---

## 🛠️ Tools & Technologies

* **SQL (SQL)** → Data transformation and modeling
* **Microsoft SQL Server** → Database management
* **Git & GitHub** → Version control and documentation

---

## ⭐ Key Features

* End-to-end data warehouse implementation
* Medallion architecture (Bronze, Silver, Gold)
* Star schema data modeling
* Data cleaning and validation framework
* Structured project organization

---

## 📊 Sample Queries

```sql
-- View top 10 sales records
SELECT TOP 10 *
FROM gold.fact_sales;

-- Total sales by customer
SELECT customer_key, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY customer_key;
```

---

## ⚙️ How to Run This Project

1. Clone the repository:

```bash
git clone https://github.com/michaelablert226/SQL-DATAWAREHOUSE-PROJECT.git
```

2. Load raw datasets into SQL Server

3. Execute scripts in order:

* Bronze layer scripts
* Silver layer scripts
* Gold layer scripts

4. Run test queries from the `/tests` folder to validate outputs

---

## 🚧 Challenges & Solutions

**1. Inconsistent Data Formats**

* Solution: Applied standardization rules during the Silver layer transformation

**2. Missing Values**

* Solution: Implemented data cleaning and default handling strategies

**3. Data Integration Across Systems**

* Solution: Created unified keys and mapping logic to join CRM and ERP datasets

---

## 🔮 Future Improvements

* Integration with BI tools (Power BI / Tableau)
* Incremental data loading
* Pipeline orchestration using Apache Airflow
* Automated data quality monitoring
* Performance optimization for large datasets

---

## 👤 Author

**Michael Adamu Egietsemeh**
Data Analyst | Aspiring Data Engineer

---

## 📝 Notes

This project is part of my data engineering learning journey and reflects practical implementation of modern data warehouse design principles.
