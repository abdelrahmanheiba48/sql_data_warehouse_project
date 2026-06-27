-- ============================================
-- DDL Script: Bronze Layer Tables
-- Purpose:    Create all raw staging tables
-- ============================================
USE DataWarehouse
GO
-- ============================================
-- Table: bronze.crm_cust_info
-- Source: CRM System
-- Description: Raw customer information
-- ============================================
PRINT '>> Creating table: bronze.crm_cust_info';

DROP TABLE IF EXISTS bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
	cst_id NVARCHAR(50),
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status CHAR(1),
	cst_gndr CHAR(1),
	cst_create_date DATE
);
PRINT '>> Done: bronze.crm_prd_info created successfully';
GO

PRINT '>> Creating table: bronze.crm_prd_info';

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost DECIMAL(10,2),
	prd_line CHAR(1),
	prd_start_dt DATE,
	prd_end_dt DATE
);
PRINT '>> Done: bronze.crm_prd_info created successfully';
GO

PRINT '>> Creating table: bronze.crm_sales_details';

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id NVARCHAR(50),
	sls_order_dt DATETime2,
	sls_ship_dt DATETime2,
	sls_due_dt DATETime2,
	sls_sales DECIMAL(10,2),
	sls_quantity INT,
	sls_price DECIMAL(10,2)
);
PRINT '>> Done: bronze.crm_sales_details created successfully';
GO
PRINT '>> Creating table: bronze.erp_CUST_AZ12';

DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(10)
);
PRINT '>> Done: bronze.erp_CUST_AZ12 created successfully';
GO
PRINT '>> Creating table: bronze.erp_LOC_A101';

DROP TABLE IF EXISTS bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);
PRINT '>> Done: bronze.erp_LOC_A101 created successfully';
GO
PRINT '>> Creating table: bronze.PX_CAT_G1V2';

DROP TABLE IF EXISTS bronze.PX_CAT_G1V2;
CREATE TABLE bronze.PX_CAT_G1V2(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
PRINT '>> Done: bronze.PX_CAT_G1V2 created successfully';
GO
