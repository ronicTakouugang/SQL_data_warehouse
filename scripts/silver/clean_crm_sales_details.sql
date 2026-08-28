-- ============================================================
-- Data Warehouse: Silver Layer
-- Clean CRM Sales Details
-- ============================================================

USE DataWarehouse;
GO

TRUNCATE TABLE silver.crm_sales_details;
GO

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,

    TRY_CONVERT(INT, NULLIF(TRIM(sls_cust_id), '')) AS sls_cust_id,

    CASE
        WHEN TRY_CONVERT(INT, sls_order_dt) = 0
             OR LEN(TRIM(sls_order_dt)) != 8
        THEN NULL
        ELSE TRY_CONVERT(DATE, sls_order_dt, 112)
    END AS sls_order_dt,

    CASE
        WHEN TRY_CONVERT(INT, sls_ship_dt) = 0
             OR LEN(TRIM(sls_ship_dt)) != 8
        THEN NULL
        ELSE TRY_CONVERT(DATE, sls_ship_dt, 112)
    END AS sls_ship_dt,

    CASE
        WHEN TRY_CONVERT(INT, sls_due_dt) = 0
             OR LEN(TRIM(sls_due_dt)) != 8
        THEN NULL
        ELSE TRY_CONVERT(DATE, sls_due_dt, 112)
    END AS sls_due_dt,

    CASE
        WHEN TRY_CONVERT(DECIMAL(18,2), sls_sales) IS NULL
             OR TRY_CONVERT(DECIMAL(18,2), sls_sales) <= 0
             OR TRY_CONVERT(DECIMAL(18,2), sls_sales) !=
                TRY_CONVERT(INT, sls_quantity) *
                ABS(TRY_CONVERT(DECIMAL(18,2), sls_price))
        THEN
            TRY_CONVERT(INT, sls_quantity) *
            ABS(TRY_CONVERT(DECIMAL(18,2), sls_price))
        ELSE
            TRY_CONVERT(DECIMAL(18,2), sls_sales)
    END AS sls_sales,

    TRY_CONVERT(INT, sls_quantity) AS sls_quantity,

    CASE
        WHEN TRY_CONVERT(DECIMAL(18,2), sls_price) IS NULL
             OR TRY_CONVERT(DECIMAL(18,2), sls_price) <= 0
        THEN
            TRY_CONVERT(DECIMAL(18,2), sls_sales) /
            NULLIF(TRY_CONVERT(INT, sls_quantity), 0)
        ELSE
            TRY_CONVERT(DECIMAL(18,2), sls_price)
    END AS sls_price

FROM bronze.crm_sales_details;
GO