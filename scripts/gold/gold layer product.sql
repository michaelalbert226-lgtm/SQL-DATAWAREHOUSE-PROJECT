/* ============================================================
   GOLD LAYER - DIMENSION TABLE: PRODUCTS
   ============================================================
   PURPOSE:
   - Create a product dimension table
   - Enrich product data with category information
   - Filter only active/current products

   SOURCE TABLES:
   - silver.crm_prd_info (product master data)
   - silver.erp_px_cat_g1v2 (category mapping)

   NOTES:
   - Uses ROW_NUMBER() as surrogate key
   - Filters out historical/inactive products (prd_end_dt IS NULL)
   ============================================================ */

CREATE VIEW gold.dim_products AS
SELECT
    -- Surrogate key
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    -- Business keys
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,

    -- Product attributes
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,

    -- Financial & operational attributes
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn 

-- Join category information
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id

-- Only include active products
WHERE pn.prd_end_dt IS NULL;
