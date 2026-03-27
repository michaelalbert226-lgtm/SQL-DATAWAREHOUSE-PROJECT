/* ============================================================
   GOLD LAYER - DIMENSION TABLE: CUSTOMERS
   ============================================================
   PURPOSE:
   - Create a customer dimension table for analytics
   - Combines CRM and ERP customer data
   - Cleans and standardizes gender information
   - Adds surrogate key (customer_key)

   SOURCE TABLES:
   - silver.crm_cust_info (primary customer data)
   - silver.erp_cust_az12 (additional attributes e.g. gender, birthdate)
   - silver.erp_loc_a101 (location data)

   NOTES:
   - Uses ROW_NUMBER() to generate surrogate key
   - Handles missing gender using fallback logic
   ============================================================ */

CREATE VIEW gold.dim_customers AS
SELECT
    -- Surrogate key (unique per customer, used for joins in fact table)
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,

    -- Business keys
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,

    -- Customer attributes
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_material_status AS marital_status,

    -- Gender cleansing logic:
    -- Priority: CRM data → ERP fallback → default 'n/a'
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    -- Additional attributes
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

-- Join ERP customer additional attributes
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid

-- Join location data
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
