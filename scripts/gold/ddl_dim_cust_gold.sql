-- ============================================================
-- Data Warehouse: Gold Layer
-- Dimension: Customer
-- ============================================================

USE DataWarehouse;
GO

CREATE OR ALTER VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,

    CASE
        WHEN ci.cst_gndr != 'N/A'
            THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'N/A')
    END AS gender,

    ci.cst_marital_status AS marital_status,
    ca.bdate AS birth_date,
    la.cntry AS country,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO