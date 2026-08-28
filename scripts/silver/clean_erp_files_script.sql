-- ============================================================
-- Data Warehouse: Silver Layer
-- Clean ERP Tables
-- ============================================================

USE DataWarehouse;
GO


-- ERP Customer Information

TRUNCATE TABLE silver.erp_cust_az12;
GO

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE
        WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
        ELSE TRIM(cid)
    END AS cid,

    CASE
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,

    CASE
        WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS gen

FROM bronze.erp_cust_az12;
GO


-- ERP Location Information

TRUNCATE TABLE silver.erp_loc_a101;
GO

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT DISTINCT
    REPLACE(TRIM(cid), '-', '') AS cid,

    CASE
        WHEN TRIM(cntry) = 'DE'
            THEN 'Germany'

        WHEN TRIM(cntry) IN ('US', 'USA')
            THEN 'United States'

        WHEN TRIM(cntry) = ''
             OR cntry IS NULL
            THEN 'N/A'

        ELSE TRIM(cntry)
    END AS cntry

FROM bronze.erp_loc_a101;
GO


-- ERP Product Category

TRUNCATE TABLE silver.erp_px_cat_g1v2;
GO

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT DISTINCT
    COALESCE(
        NULLIF(TRIM(id), ''),
        'N/A'
    ) AS id,

    COALESCE(
        NULLIF(TRIM(cat), ''),
        'N/A'
    ) AS cat,

    COALESCE(
        NULLIF(TRIM(subcat), ''),
        'N/A'
    ) AS subcat,

    COALESCE(
        NULLIF(TRIM(maintenance), ''),
        'N/A'
    ) AS maintenance

FROM bronze.erp_px_cat_g1v2;
GO