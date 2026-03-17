    -- =============================================================================
-- Procedure: bronze.load_bronze
-- Purpose: Load raw data from CSV files into bronze layer tables
-- Description: This procedure truncates and reloads CRM and ERP data into the bronze schema
--              for staging in the data warehouse. Includes timing and error handling.
-- Author: Mikkymayor
-- Created: 2026-03-18
-- =============================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
    BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;

    BEGIN TRY

    print '================================================================';
    print 'Loading data into crm bronze layer...';
    print '================================================================';

    --insert csv file in to bronze table
    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.crm_cust_info...';
    truncate table bronze.crm_cust_info;
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    );
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';   


    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.crm_prd_info...';
    Truncate table bronze.crm_prd_info;
    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    );
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';


    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.crm_sales_details...';
    truncate table bronze.crm_sales_details;
    BULK INSERT bronze.crm_sales_details    
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    );
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';



    print '================================================================';
    print 'Loading data into bronze erp layer...';
    print '================================================================';

    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.erp_cust_az12...';
    TRUNCATE TABLE bronze.erp_cust_az12;
    BULK INSERT bronze.erp_cust_az12
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'            
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    ) 
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';

    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.erp_cust_loc_a101...';
    TRUNCATE TABLE bronze.erp_loc_a101;
    BULK INSERT bronze.erp_loc_a101
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    ) 
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';   

    SET @start_time = GETDATE();
    print 'truncating and loading data into bronze.erp_cust_loc_a101...';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'C:\Users\micha\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,           -- Skip CSV header row
        TABLOCK                 -- Lock table for faster import
    )       
    SET @end_time = GETDATE();
    print '>>Load duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    Print '----------------------------------------------------------------';   


    END TRY
    BEGIN CATCH
        print 'Error loading data into bronze layer: ' + ERROR_MESSAGE();   

    END CATCH
    END

    

    
