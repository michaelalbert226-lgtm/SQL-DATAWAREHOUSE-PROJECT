USE Datawarehouse;
GO

PRINT '=========================================';
PRINT 'STARTING SILVER LAYER DATA QUALITY CHECKS';
PRINT '=========================================';

------------------------------------------------------------
-- 1. CUSTOMER DATA CHECKS (silver.crm_cust_info)
------------------------------------------------------------

PRINT 'Running checks for: silver.crm_cust_info';

-- NULL CHECK
SELECT 'crm_cust_info - NULL CHECK' AS check_name, *
FROM silver.crm_cust_info
WHERE cst_id IS NULL OR cst_key IS NULL;

-- DUPLICATE CHECK
SELECT 'crm_cust_info - DUPLICATE CHECK' AS check_name, cst_id, COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- INVALID GENDER
SELECT 'crm_cust_info - INVALID GENDER' AS check_name, DISTINCT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr NOT IN ('Male','Female','n/a');

-- INVALID MARITAL STATUS
SELECT 'crm_cust_info - INVALID MARITAL STATUS' AS check_name, DISTINCT cst_material_status
FROM silver.crm_cust_info
WHERE cst_material_status NOT IN ('Single','Married','n/a');

-- EMPTY NAMES
SELECT 'crm_cust_info - EMPTY NAMES' AS check_name, *
FROM silver.crm_cust_info
WHERE TRIM(cst_firstname) = '' OR TRIM(cst_lastname) = '';


------------------------------------------------------------
-- 2. PRODUCT DATA CHECKS (silver.crm_prd_info)
------------------------------------------------------------

PRINT 'Running checks for: silver.crm_prd_info';

-- NULL KEYS
SELECT 'crm_prd_info - NULL CHECK' AS check_name, *
FROM silver.crm_prd_info
WHERE prd_id IS NULL OR prd_key IS NULL;

-- DUPLICATES
SELECT 'crm_prd_info - DUPLICATE CHECK' AS check_name, prd_id, COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- NEGATIVE COST
SELECT 'crm_prd_info - NEGATIVE COST' AS check_name, *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- INVALID PRODUCT LINE
SELECT 'crm_prd_info - INVALID PRODUCT LINE' AS check_name, DISTINCT prd_line
FROM silver.crm_prd_info
WHERE prd_line NOT IN ('MOUNTAIN','ROAD','OTHER SALES','TOURING','N/A');

-- INVALID DATE RANGE
SELECT 'crm_prd_info - INVALID DATE RANGE' AS check_name, *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


------------------------------------------------------------
-- 3. SALES DATA CHECKS (silver.crm_sales_details)
------------------------------------------------------------

PRINT 'Running checks for: silver.crm_sales_details';

-- NULL KEYS
SELECT 'crm_sales_details - NULL CHECK' AS check_name, *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL 
   OR sls_prd_key IS NULL
   OR sls_cust_id IS NULL;

-- NEGATIVE VALUES
SELECT 'crm_sales_details - NEGATIVE VALUES' AS check_name, *
FROM silver.crm_sales_details
WHERE sls_sales < 0
   OR sls_quantity < 0
   OR sls_price < 0;

-- SALES CONSISTENCY
SELECT 'crm_sales_details - SALES MISMATCH' AS check_name, *
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price;

-- INVALID DATES
SELECT 'crm_sales_details - FUTURE DATES' AS check_name, *
FROM silver.crm_sales_details
WHERE sls_order_dt > GETDATE()
   OR sls_ship_dt > GETDATE()
   OR sls_due_dt > GETDATE();

-- DATE LOGIC ERROR
SELECT 'crm_sales_details - SHIP BEFORE ORDER' AS check_name, *
FROM silver.crm_sales_details
WHERE sls_ship_dt < sls_order_dt;


------------------------------------------------------------
-- 4. ERP CUSTOMER CHECKS (silver.erp_cust_az12)
------------------------------------------------------------

PRINT 'Running checks for: silver.erp_cust_az12';

-- NULL ID
SELECT 'erp_cust_az12 - NULL CID' AS check_name, *
FROM silver.erp_cust_az12
WHERE cid IS NULL;

-- FUTURE BIRTHDATE
SELECT 'erp_cust_az12 - FUTURE BDATE' AS check_name, *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- INVALID GENDER
SELECT 'erp_cust_az12 - INVALID GENDER' AS check_name, DISTINCT gen
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male','Female','n/a');


------------------------------------------------------------
-- 5. ERP LOCATION CHECKS (silver.erp_loc_a101)
------------------------------------------------------------

PRINT 'Running checks for: silver.erp_loc_a101';

-- NULL CID
SELECT 'erp_loc_a101 - NULL CID' AS check_name, *
FROM silver.erp_loc_a101
WHERE cid IS NULL;

-- INVALID COUNTRY
SELECT 'erp_loc_a101 - INVALID COUNTRY' AS check_name, DISTINCT cntry
FROM silver.erp_loc_a101
WHERE cntry IS NULL OR cntry = '';

-- UNEXPECTED CHARACTERS
SELECT 'erp_loc_a101 - INVALID CID FORMAT' AS check_name, *
FROM silver.erp_loc_a101
WHERE cid LIKE '%-%';


------------------------------------------------------------
-- 6. PRODUCT CATEGORY CHECKS (silver.erp_px_cat_g1v2)
------------------------------------------------------------

PRINT 'Running checks for: silver.erp_px_cat_g1v2';

-- NULL VALUES
SELECT 'erp_px_cat_g1v2 - NULL CHECK' AS check_name, *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL OR cat IS NULL;

-- DUPLICATES
SELECT 'erp_px_cat_g1v2 - DUPLICATE CHECK' AS check_name, id, COUNT(*) AS duplicate_count
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

-- EMPTY VALUES
SELECT 'erp_px_cat_g1v2 - EMPTY VALUES' AS check_name, *
FROM silver.erp_px_cat_g1v2
WHERE TRIM(cat) = '' OR TRIM(subcat) = '';


------------------------------------------------------------
-- 7. OVERALL DATA HEALTH CHECK
------------------------------------------------------------

PRINT 'Running overall row count check';

SELECT 'crm_cust_info' AS table_name, COUNT(*) FROM silver.crm_cust_info
UNION ALL
SELECT 'crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL
SELECT 'crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL
SELECT 'erp_cust_az12', COUNT(*) FROM silver.erp_cust_az12
UNION ALL
SELECT 'erp_loc_a101', COUNT(*) FROM silver.erp_loc_a101
UNION ALL
SELECT 'erp_px_cat_g1v2', COUNT(*) FROM silver.erp_px_cat_g1v2;

PRINT '=========================================';
PRINT 'DATA QUALITY CHECKS COMPLETED';
PRINT '=========================================';
