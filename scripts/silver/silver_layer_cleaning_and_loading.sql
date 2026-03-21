USE Datawarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @proc_start_time DATETIME = GETDATE(),
        @step_start_time DATETIME,
        @step_end_time DATETIME;

    BEGIN TRY

    PRINT '=========================================';
    PRINT 'STARTING SILVER LAYER LOAD';
    PRINT '=========================================';

    ---------------------------------------------------
    -- 1. LOAD CUSTOMER INFO
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    PRINT 'Loading: silver.crm_cust_info';

    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname, 
        cst_material_status, cst_gndr, cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),

        CASE 
            WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,

        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END,

        cst_create_date

    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
        FROM bronze.crm_cust_info
    ) t
    WHERE rn = 1;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- 2. LOAD PRODUCT INFO
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    PRINT 'Loading: silver.crm_prd_info';

    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm,
        prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT 
        prd_id,

        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),

        SUBSTRING(prd_key, 7, LEN(prd_key)),

        prd_nm,

        ISNULL(prd_cost, 0),

        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'MOUNTAIN'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'ROAD'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'OTHER SALES'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'TOURING'
            ELSE 'N/A'
        END,

        CAST(prd_start_dt AS DATE),

        CAST(
            DATEADD(DAY, -1,
                LEAD(prd_start_dt) OVER (
                    PARTITION BY SUBSTRING(prd_key, 7, LEN(prd_key))
                    ORDER BY prd_start_dt
                )
            ) AS DATE
        )

    FROM bronze.crm_prd_info;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- 3. LOAD SALES DETAILS
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    PRINT 'Loading: silver.crm_sales_details';

    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id,
        sls_order_dt, sls_ship_dt, sls_due_dt,
        sls_sales, sls_quantity, sls_price
    )
    SELECT  
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        CASE 
            WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END,

        CASE 
            WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END,

        CASE 
            WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END,

        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_price * sls_quantity
                THEN sls_quantity * ABS(sls_price)
            ELSE ABS(sls_sales)
        END,

        sls_quantity,

        CASE 
            WHEN sls_price IS NULL AND sls_quantity <> 0 THEN sls_sales / sls_quantity
            ELSE ABS(sls_price)
        END

    FROM bronze.crm_sales_details;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- 4. LOAD ERP CUSTOMER
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    PRINT 'Loading: silver.erp_cust_az12';

    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
            ELSE cid 
        END,

        CASE 
            WHEN bdate > GETDATE() THEN NULL 
            ELSE bdate 
        END,

        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a'
        END

    FROM bronze.erp_cust_az12;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- 5. LOAD ERP LOCATION
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    PRINT 'Loading: silver.erp_loc_a101';

    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        REPLACE(cid, '-', ''),
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END

    FROM bronze.erp_loc_a101;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- 6. LOAD PRODUCT CATEGORY
    ---------------------------------------------------
    SET @step_start_time = GETDATE();

    PRINT 'Truncating: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    PRINT 'Loading: silver.erp_px_cat_g1v2';

    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM bronze.erp_px_cat_g1v2;

    SET @step_end_time = GETDATE();
    PRINT 'Completed in ' + CAST(DATEDIFF(SECOND, @step_start_time, @step_end_time) AS NVARCHAR) + ' sec';


    ---------------------------------------------------
    -- FINAL LOG
    ---------------------------------------------------
    PRINT '=========================================';
    PRINT 'SILVER LAYER LOAD COMPLETED';
    PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @proc_start_time, GETDATE()) AS NVARCHAR) + ' sec';
    PRINT '=========================================';

    END TRY
    BEGIN CATCH

        PRINT '=========================================';
        PRINT 'ERROR DURING SILVER LOAD';
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================';

        THROW; -- very important for production

    END CATCH
END;
GO




 
