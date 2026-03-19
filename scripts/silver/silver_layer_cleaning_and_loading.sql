-- Building silver layer cleaning & loading for customer information 

INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_material_status, cst_gndr, cst_create_date)
    SELECT cst_id, cst_key,
    TRIM(cst_firstname) AS cst_firstname,
     TRIM(cst_lastname) AS cst_lastname,
   
     case when UPPER(TRIM(cst_material_status)) = 'S' then 'Single'
          when UPPER(TRIM(cst_material_status)) = 'M' then 'Married'
          else 'n/a'
    end as cst_material_status,
 
    case when UPPER(TRIM(cst_gndr)) = 'M' then 'Male'
         when UPPER(TRIM(cst_gndr)) = 'F' then 'Female'
         else 'n/a'
    end as cst_gndr,
    cst_create_date
FROM
 (
    select *,
    ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank
    from bronze.crm_cust_info
)sub 
WHERE rank = 1;


-- Building silver layer cleaning & loading for product information
--insert into silver layer
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,

    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,

    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,

    prd_nm,

    ISNULL(prd_cost, 0) AS prd_cost,

    CASE 
        WHEN UPPER(LTRIM(RTRIM(prd_line))) = 'M' THEN 'MOUNTAIN'
        WHEN UPPER(LTRIM(RTRIM(prd_line))) = 'R' THEN 'ROAD'
        WHEN UPPER(LTRIM(RTRIM(prd_line))) = 'S' THEN 'OTHER SALES'
        WHEN UPPER(LTRIM(RTRIM(prd_line))) = 'T' THEN 'TOURING'
        ELSE 'N/A'
    END AS prd_line,

    CAST(prd_start_dt AS DATE) AS prd_start_dt,

    CAST(
        DATEADD(DAY, -1,
            LEAD(prd_start_dt) OVER (
                PARTITION BY SUBSTRING(prd_key, 7, LEN(prd_key))
                ORDER BY prd_start_dt
            )
        ) AS DATE
    ) AS prd_end_dt

FROM bronze.crm_prd_info;













