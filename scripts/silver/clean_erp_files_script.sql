-- ============================================================
-- Data Warehouse: Silver Layer
-- Stored Procedure: silver.load_silver
-- ============================================================
-- Scripts Purpose:
--     This stored procedure loads and transforms data from the
--     Bronze Layer into the Silver Layer.
--
--     The procedure applies data cleansing and standardization
--     rules before inserting the data into the Silver tables.
--
-- Actions:
--     - Truncates existing Silver tables before loading.
--     - Cleans and standardizes ERP customer information.
--     - Removes unnecessary prefixes and spaces from customer IDs.
--     - Validates customer birth dates.
--     - Standardizes gender values.
--     - Cleans and standardizes country information.
--     - Removes duplicate location records.
--     - Cleans ERP product category information.
--     - Replaces missing or empty values with 'N/A'.
--     - Tracks the execution time of each loading step.
--     - Reports the number of rows loaded for each table.
--     - Handles errors using TRY...CATCH.
--     - Reports the total execution time of the Silver Layer.
--
-- Parameters:
--     None.
--     This procedure does not require any input parameters.
--
-- Usage Example:
--     EXEC silver.load_silver;
--
-- ============================================================
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartTime DATETIME2;
    DECLARE @EndTime DATETIME2;
    DECLARE @DurationSeconds INT;
    DECLARE @StartLoadTime DATETIME2 = SYSDATETIME();

    BEGIN TRY

        PRINT '============================================================';
        PRINT 'Loading the Silver Layer';
        PRINT '============================================================';


        -- ERP Customer Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Customer Information...';

        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT 'Loading ERP Customer Information...';

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE
                WHEN TRIM(cid) LIKE 'NAS%'
                    THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
                ELSE TRIM(cid)
            END AS cid,

            CASE
                WHEN bdate > GETDATE()
                    THEN NULL
                ELSE bdate
            END AS bdate,

            CASE
                WHEN UPPER(TRIM(gen)) = 'M'
                    THEN 'Male'
                WHEN UPPER(TRIM(gen)) = 'F'
                    THEN 'Female'
                ELSE 'N/A'
            END AS gen

        FROM bronze.erp_cust_az12;

        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Customer Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- ERP Location Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Location Information...';

        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT 'Loading ERP Location Information...';

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

        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Location Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- ERP Product Category

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Product Category...';

        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT 'Loading ERP Product Category...';

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

        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Product Category loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- Load Summary

        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartLoadTime, @EndTime);

        PRINT '';
        PRINT '============================================================';
        PRINT 'Silver Layer loaded successfully.';
        PRINT 'Total Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';
        PRINT '============================================================';


    END TRY

    BEGIN CATCH

        PRINT '';
        PRINT '============================================================';
        PRINT 'ERROR: Silver Layer loading failed.';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(20));
        PRINT '============================================================';

        THROW;

    END CATCH

END;
GO