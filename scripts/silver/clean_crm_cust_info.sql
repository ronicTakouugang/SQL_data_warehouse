-- ============================================================
-- Data Warehouse: Silver Layer
-- Clean CRM Customer Information
-- ============================================================

USE DataWarehouse;
GO

TRUNCATE TABLE silver.crm_cust_info;
GO

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,

    COALESCE(
        NULLIF(TRIM(cst_key), ''),
        'N/A'
    ) AS cst_key,

    COALESCE(
        NULLIF(TRIM(cst_firstname), ''),
        'N/A'
    ) AS cst_firstname,

    COALESCE(
        NULLIF(TRIM(cst_lastname), ''),
        'N/A'
    ) AS cst_lastname,

    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'N/A'
    END AS cst_marital_status,

    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS cst_gndr,

    cst_create_date

FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        ) AS rn
    FROM bronze.crm_cust_info
) AS cleaned_data
WHERE rn = 1;
GO

