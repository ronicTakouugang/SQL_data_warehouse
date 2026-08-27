-- ============================================================
-- Data Warehouse: Bronze Layer
-- Load Bronze Procedure
-- ============================================================

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    TRUNCATE TABLE bronze.crm_cust_info;

    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


    TRUNCATE TABLE bronze.crm_prd_info;

    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


    TRUNCATE TABLE bronze.crm_sales_details;

    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


    TRUNCATE TABLE bronze.erp_cust_az12;

    BULK INSERT bronze.erp_cust_az12
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\CUST_AZ12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


    TRUNCATE TABLE bronze.erp_loc_a101;

    BULK INSERT bronze.erp_loc_a101
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\LOC_A101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'C:\Users\ronic\Desktop\SQL_data_warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (-- ============================================================
-- Data Warehouse: Bronze Layer
-- Load Bronze Procedure
-- ============================================================

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    PRINT '--------------';
    PRINT 'Loading the Bronze Layer';
    PRINT '--------------';


    -- CRM Customer Information

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

    PRINT 'CRM Customer Information loaded successfully.';


    -- CRM Product Information

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

    PRINT 'CRM Product Information loaded successfully.';


    -- CRM Sales Details

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

    PRINT 'CRM Sales Details loaded successfully.';


    -- ERP Customer Information

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

    PRINT 'ERP Customer Information loaded successfully.';


    -- ERP Location Information

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

    PRINT 'ERP Location Information loaded successfully.';


    -- ERP Product Category

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

    PRINT 'ERP Product Category loaded successfully.';


    PRINT '--------------';
    PRINT 'Bronze Layer loaded successfully.';
    PRINT '--------------';

END;
GO
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

END;
GO