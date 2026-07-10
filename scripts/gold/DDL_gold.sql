/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

PRINT '>> Creating view: gold.dim_customer';
DROP VIEW IF EXISTS gold.dim_customer;
CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_firstname AS first_name,
	CI.cst_lastname AS last_name,
	LC.CNTRY AS	country,
	CI.cst_marital_status AS marital_state,
	CASE
		WHEN CI.cst_gndr != 'N/A'
		THEN CI.cst_gndr
		ELSE COALESCE(CE.GEN ,'N/A')
	END AS gender,
	CI.cst_create_date AS create_date,
	CE.BDATE AS birthdate 
FROM silver.crm_cust_info AS CI
LEFT JOIN silver.erp_CUST_AZ12 AS CE
ON CI.cst_KEY = CE.CID
LEFT JOIN silver.erp_LOC_A101 AS LC
ON CI.cst_key = LC.CID;
PRINT '>> Done : gold.dim_customer Created successfully'
--=========================================================================

PRINT '>> Creating view: gold.dim_product';
DROP VIEW IF EXISTS gold.dim_product;
CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER(ORDER BY prd_start_dt ,prd_key) AS product_key,
	PD.prd_id AS product_id,
	PD.prd_key AS product_number,
	PD.prd_nm AS product_name,
	PD.cat_id AS  category_id,
	PX.CAT AS category,
	PX.SUBCAT AS subcategory,
	PX.MAINTENANCE AS maintenance_required,
	PD.prd_cost AS cost,
	PD.prd_line AS product_line,
	PD.prd_start_dt AS start_dt 
FROM silver.crm_prd_info AS PD
LEFT JOIN silver.erp_PX_CAT_G1V2 AS PX
ON PD.cat_id = PX.ID
WHERE PD.prd_end_dt IS NULL ;
PRINT '>> Done : gold.dim_product Created successfully'
--==================================================================================

PRINT '>> Creating view: gold.fact_sales';
DROP VIEW IF EXISTS gold.fact_sales;
CREATE VIEW gold.fact_sales AS
SELECT
	SL.sls_ord_num AS order_number ,
	PR.product_key,
	CU.customer_id,
	SL.sls_order_dt AS order_date,
	SL.sls_ship_dt AS shipping_date,
	SL.sls_due_dt AS due_date,
	SL.sls_sales AS sales_amount,
	SL.sls_quantity AS quantity,
	SL.sls_price AS price
FROM silver.crm_sales_details AS SL
LEFT JOIN gold.dim_customer AS CU
ON SL.sls_cust_id = CU.customer_id
LEFT JOIN gold.dim_product AS PR
ON SL.sls_prd_key = PR.product_number;
PRINT '>> Done : gold.fact_sales Created successfully'

