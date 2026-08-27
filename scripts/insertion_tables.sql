-- ============================================================
-- Data Warehouse: Bronze Layer
-- Load Bronze Procedure
-- ============================================================

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartTime DATETIME2;
    DECLARE @EndTime DATETIME2;
    DECLARE @DurationSeconds INT;
    DECLARE @StartLoadTime DATETIME2 = SYSDATETIME();
    DECLARE @RowsLoaded BIGINT;

    BEGIN TRY

        PRINT '============================================================';
        PRINT 'Loading the Bronze Layer';
        PRINT '============================================================';


        -- CRM Customer Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating CRM Customer Information...';

        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT 'Loading CRM Customer Information...';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'CRM Customer Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- CRM Product Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating CRM Product Information...';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT 'Loading CRM Product Information...';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'CRM Product Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- CRM Sales Details

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating CRM Sales Details...';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT 'Loading CRM Sales Details...';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'CRM Sales Details loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- ERP Customer Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Customer Information...';

        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT 'Loading ERP Customer Information...';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Customer Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- ERP Location Information

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Location Information...';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT 'Loading ERP Location Information...';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Location Information loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- ERP Product Category

        SET @StartTime = SYSDATETIME();

        PRINT '';
        PRINT 'Truncating ERP Product Category...';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT 'Loading ERP Product Category...';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @RowsLoaded = @@ROWCOUNT;
        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartTime, @EndTime);

        PRINT 'ERP Product Category loaded successfully.';
        PRINT 'Rows loaded: ' + CAST(@RowsLoaded AS VARCHAR(20));
        PRINT 'Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';


        -- Load Summary

        SET @EndTime = SYSDATETIME();
        SET @DurationSeconds = DATEDIFF(SECOND, @StartLoadTime, @EndTime);

        PRINT '';
        PRINT '============================================================';
        PRINT 'Bronze Layer loaded successfully.';
        PRINT 'Total Duration: ' + CAST(@DurationSeconds AS VARCHAR(20)) + ' seconds';
        PRINT '============================================================';


    END TRY

    BEGIN CATCH

        PRINT '';
        PRINT '============================================================';
        PRINT 'ERROR: Bronze Layer loading failed.';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(20));
        PRINT '============================================================';

        THROW;

    END CATCH

END;
GO