# 🚀 SQL Data Warehouse Project

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-blue?logo=microsoftsqlserver\&logoColor=white)
![T-SQL](https://img.shields.io/badge/Language-T--SQL-informational)
![Architecture](https://img.shields.io/badge/Architecture-Medallion%20\(Bronze%20%7C%20Silver%20%7C%20Gold\)-orange)
![Modeling](https://img.shields.io/badge/Data%20Model-Star%20Schema-success)
![Git](https://img.shields.io/badge/Version%20Control-Git-black?logo=git)
![GitHub stars](https://img.shields.io/github/stars/your-username/SQL-DATAWAREHOUSE-PROJECT?style=social)
![GitHub forks](https://img.shields.io/github/forks/your-username/SQL-DATAWAREHOUSE-PROJECT?style=social)

---

## 📌 Overview

This project demonstrates the end-to-end design and implementation of a modern **data warehouse** using SQL Server. It follows the **Medallion Architecture (Bronze → Silver → Gold)** to transform raw data into clean, structured, and analytics-ready datasets.

The solution simulates a real-world retail environment by integrating data from multiple source systems (**CRM & ERP**) and delivering a business-ready data model for reporting and insights.

---

## 🏗️ Data Architecture 
The data warehouse is structured using the Medallion Architecture:
* **Bronze Layer:** Raw data ingested directly from the source systems with minimal transformation.
* **Silver Layer:** Cleaned, standardized, and validated data to ensure consistency and quality.
* **Gold Layer:** Business-ready data models optimized for analytics and reporting.
‎

‎![Architecture](docs/diagrams/Bronze_layer_diagram.drawio.png)

---

## 🔁 Data Flow
* Data is extracted from CRM & ERP systems
* Loaded into bronze layer tables
* Transformed and validated in Silver layer
* Modeled into fact and dimension tables in Gold layer

‎![Data Flow](docs/diagrams/Data_flow.png)

‎
---
‎
## 🗃️ Data integration
This project integrates multiple datasets:
* **CRM system** → Customer and sales data
* **ERP system** → product and location data
These datasets are joined and transformed to produce a unified analytical model.

‎![Date integration](docs/diagrams/data_integration.png)

---

## 🗂️ Project Structure

```bash
SQL-DATAWAREHOUSE-PROJECT/
│
├── bronze/
│   ├── load_crm.sql
│   ├── load_erp.sql
│
├── silver/
│   ├── clean_customers.sql
│   ├── clean_products.sql
│
├── gold/
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   ├── fact_sales.sql
│
├── tests/
│   ├── test_queries.sql
│
├── docs/
│   ├── architecture.png
│   ├── data_model.png
│
└── README.md
```

---

## 🧱 Data Model (Star Schema)
The Gold layer is designed using a star schema:
‎
### Fact Table
‎
* `gold.fact_sales` → Stores transactional sales data
‎
### Dimension Tables
‎
* `gold.dim_customers` → Customer information
* `gold.dim_products` → Product details
‎
‎This structure enables efficient querying and reporting.

### Star Schema diagram 
!‎[Sales Mart Data](docs/diagrams/sales_mart.drawio.png)

---

## 📊 Sample Results

### 🔹 Top Sales Records

![Sample Query Result](docs/sample_results.png)

> Replace with your actual screenshot after running queries.

---

## 📊 Sample Queries

```sql
SELECT TOP 10 *
FROM gold.fact_sales;

SELECT customer_key, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY customer_key;
```

---

## ⚙️ How to Run This Project

1. Clone the repository:

```bash
git clone https://github.com/your-username/SQL-DATAWAREHOUSE-PROJECT.git
```

2. Load raw datasets into SQL Server

3. Execute scripts in order:

* Bronze
* Silver
* Gold

4. Run test queries from `/tests`

---

## 🚧 Challenges & Solutions

**Inconsistent Data Formats**
Standardized during Silver layer

**Missing Values**
Handled with default values and cleaning logic

**Data Integration**
Unified keys across CRM and ERP

---

## 🔮 Future Improvements

* Power BI dashboard integration
* Incremental loading (CDC)
* Airflow orchestration
* Data quality checks automation

---

## 👤 Author

**Michael Adamu Egietsemeh**
Data Analyst | Aspiring Data Engineer

---

## ⭐ If you like this project

Give it a ⭐ on GitHub and share feedback!
