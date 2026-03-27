/* ============================================================
   GOLD LAYER - FACT TABLE: SALES
   ============================================================
   PURPOSE:
   - Create fact table for sales transactions
   - Links customers and products via surrogate keys
   - Stores measurable metrics (sales, quantity, price)

   SOURCE TABLES:
   - silver.crm_sales_details (transactional sales data)
   - gold.dim_products (product dimension)
   - gold.dim_customers (customer dimension)

   GRAIN:
   - One row per sales transaction line

   NOTES:
   - Uses LEFT JOIN to retain all sales records
   - Surrogate keys ensure dimensional consistency
   ============================================================ */

CREATE VIEW gold.fact_sales AS
SELECT
    -- Transaction identifiers
    sd.sls_ord_num AS order_number,

    -- Foreign keys (link to dimensions)
    pr.product_key,
    cu.customer_key,

    -- Dates
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,

    -- Measures (facts)
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price

FROM silver.crm_sales_details sd

-- Join product dimension
LEFT JOIN gold.dim_products pr 
    ON sd.sls_prd_key = pr.product_number

-- Join customer dimension
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
