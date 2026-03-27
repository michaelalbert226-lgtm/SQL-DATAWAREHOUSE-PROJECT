## Data Dictionary For Gold Layer:

## **Overview:**
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. 
It consists of dimension tables and fact tables for specific business metrics.

## 1. gold.dim_customers

**Purpose:**  
Stores customer details enriched with demographic and geographic data.

### Columns

| Column Name      | Data Type     | Description |
|-----------------|--------------|------------|
| customer_key    | INT          | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id     | INT          | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name      | NVARCHAR(50) | The customer's first name, as recorded in the system. |
| last_name       | NVARCHAR(50) | The customer's last name or family name. |
| country         | NVARCHAR(50) | The country of residence for the customer (e.g., 'Nigeria'). |
| marital_status  | NVARCHAR(50) | The marital status of the customer (e.g., 'Married', 'Single'). |
| gender          | NVARCHAR(50) | The gender of the customer (e.g., 'Male', 'Female', 'n/a'). |
| birthdate       | DATE         | The date of birth of the customer, formatted as YYYY-MM-DD. |
| create_date     | DATE         | The date when the customer record was created in the system. |


**# 2. gold.dim_products**

**Purpose:**
Provides information about products and their attributes.

### Columns

| Column Name     | Data Type       | Description |
|----------------|----------------|------------|
| product_key    | INT            | Surrogate key uniquely identifying each product record in the dimension table. |
| product_id     | INT            | Unique numerical identifier assigned to each product. |
| product_number | NVARCHAR(50)   | Alphanumeric product code used for tracking and referencing. |
| product_name   | NVARCHAR(100)  | The name of the product. |
| category_id    | NVARCHAR(50)   | Identifier linking the product to its category. |
| category       | NVARCHAR(50)   | High-level classification of the product (e.g., 'Electronics'). |
| subcategory    | NVARCHAR(50)   | More specific classification within a category (e.g., 'Mobile Phones'). |
| maintenance    | NVARCHAR(50)   | Indicates whether the product requires maintenance or service. |
| product_cost   | DECIMAL(10,2)  | The cost of the product. |
| product_line   | NVARCHAR(50)   | The product line or grouping the product belongs to. |
| start_date     | DATE           | The date when the product became active or available. |


**## 3. gold.dim_sales**

**Purpose:**
Stores transactional sales data linking customers and products.

### Columns

| Column Name    | Data Type      | Description |
|---------------|---------------|------------|
| order_number  | NVARCHAR(50)  | Unique identifier for each sales order. |
| product_key   | INT           | Foreign key linking to the product dimension. |
| customer_key  | INT           | Foreign key linking to the customer dimension. |
| order_date    | DATE          | The date when the order was placed. |
| shipping_date | DATE          | The date when the order was shipped. |
| due_date      | DATE          | The expected delivery or due date for the order. |
| sales_amount  | DECIMAL(10,2) | Total sales amount for the transaction. |
| quantity      | INT           | Number of units sold. |
| price         | DECIMAL(10,2) | Price per unit of the product. |
