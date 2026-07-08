CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @START_TIME DATETIME , @END_TIME DATETIME , @PROC_START_TIME DATETIME , @PROC_END_TIME DATETIME 
	
	BEGIN TRY 
		SET @PROC_START_TIME = GETDATE();
		PRINT'===================================================';
		PRINT'Loading Silver Layer';
		PRINT'===================================================';
		PRINT'>>>> Loading crm Tables ....';
		PRINT'===================================================';
		
		--===================================================
		-- 1. silver.crm_cust_info
		--===================================================
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info ;
		PRINT'>>>> Loading: silver.crm_cust_info';
		
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE TRIM(UPPER(cst_marital_status))
				WHEN 'M' THEN 'Married'
				WHEN 'S' THEN 'Single'
				ELSE 'N/A'
			END AS cst_marital_status,
				CASE TRIM(UPPER(cst_gndr))
				WHEN 'F' THEN 'Female'
				WHEN 'M' THEN 'Male'
				ELSE 'N/A'
			END AS cst_gndr,
			cst_create_date
		FROM (
				SELECT
					*,
					ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_Last
				FROM bronze.crm_cust_info
				WHERE cst_id IS NOT NULL
			 ) AS  T 
		WHERE Flag_Last = 1;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR silver.crm_cust_info IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- 2. silver.crm_prd_info
		--==============================================================
		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info ;
		PRINT'>>>> Loading: silver.crm_prd_info';
	
		INSERT INTO silver.crm_prd_info(
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
			REPLACE(SUBSTRING(prd_key , 1 , 5),'-','_') AS cat_id ,
			SUBSTRING(prd_key , 7 , LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost , 0) AS prd_cost,
			CASE TRIM(UPPER(prd_line))
				 WHEN 'M' THEN 'Mountain'
				 WHEN 'S' THEN 'Other Sales'
				 WHEN 'T' THEN 'Touring'
				 WHEN 'R' THEN 'Road'
				 ELSE 'N/A'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt ,
			LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt
		FROM bronze.crm_prd_info;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR silver.crm_prd_info IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- 3. silver.crm_sales_details
		--==============================================================
		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details ;
		PRINT'>>>> Loading: silver.crm_sales_details';
	
		INSERT INTO silver.crm_sales_details(
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
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
			END AS sls_order_dt,
			CAST(sls_ship_dt AS DATE) AS sls_ship_dt ,
			CAST(sls_due_dt AS DATE) AS sls_due_dt,
			CASE 
				WHEN sls_sales != ABS(sls_quantity * sls_price) OR sls_sales IS NULL
				THEN ABS(sls_quantity * sls_price)
				ELSE sls_sales
			END AS sls_sales ,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <=0 
				THEN CAST(ABS(sls_sales/sls_quantity) AS INT)
				ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR silver.crm_sales_details IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- 4. Silver.erp_CUST_AZ12
		--==============================================================
		PRINT'==============================================================';
		PRINT'>>>> Loading erp Tables ....';
		PRINT'===================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: Silver.erp_CUST_AZ12';
		TRUNCATE TABLE Silver.erp_CUST_AZ12 ;
		PRINT'>>>> Loading: Silver.erp_CUST_AZ12';
	
		INSERT INTO Silver.erp_CUST_AZ12(
			CID,
			BDATE,
			GEN
			)
		SELECT
			CASE
				WHEN CID LIKE 'NAS%'
				THEN SUBSTRING(CID , 4 , LEN(CID))
				ELSE CID
			END AS CID,
			CASE
				WHEN BDATE > GETDATE()
				THEN NULL
				ELSE BDATE
			END AS BDTAE_NEW,
			CASE
				WHEN TRIM(UPPER(GEN)) IN ('F','FEMALE') THEN 'Female'
				WHEN TRIM(UPPER(GEN)) IN ('M','MALE') THEN 'Male'
				ELSE 'N/A'
			END AS GEN_NEW	
		FROM bronze.erp_CUST_AZ12;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR Silver.erp_CUST_AZ12 IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- 5. silver.erp_LOC_A101
		--==============================================================
		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: silver.erp_LOC_A101';
		TRUNCATE TABLE silver.erp_LOC_A101 ;
		PRINT'>>>> Loading: silver.erp_LOC_A101';
	
		INSERT INTO silver.erp_LOC_A101(
			CID,
			CNTRY
			)
		SELECT 
			REPLACE(CID , '-','') AS CID,
			CASE
				WHEN UPPER(TRIM(CNTRY)) IN ('USA' , 'US')
				THEN 'United States'
				WHEN UPPER(TRIM(CNTRY))  = 'DE'
				THEN 'Germany'
				WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL
				THEN 'N/A'
				ELSE CNTRY
			END AS CNTRY_NEW
		FROM bronze.erp_LOC_A101;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR silver.erp_LOC_A101 IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- 6. silver.erp_PX_CAT_G1V2
		--==============================================================
		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: silver.erp_PX_CAT_G1V2';
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2 ;
		PRINT'>>>> Loading: silver.erp_PX_CAT_G1V2';
	 
		INSERT INTO silver.erp_PX_CAT_G1V2(
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
			)
		SELECT * FROM bronze.erp_PX_CAT_G1V2;

		SET @END_TIME = GETDATE();
		PRINT'## LOAD DURATION FOR silver.erp_PX_CAT_G1V2 IS ' + CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME) AS NVARCHAR) + ' SECONDS';

		--==============================================================
		-- Wrap-up Metadata
		--==============================================================
		PRINT'==============================================================';
		SET @PROC_END_TIME = GETDATE();
		PRINT'==============================================================';
		PRINT'THE SILVER LAYER LOADING IS COMPLETED...';
		PRINT'THE TOTAL TIME OF THE LOADING IS: ' + CAST(DATEDIFF(SECOND,@PROC_START_TIME,@PROC_END_TIME) AS NVARCHAR) + ' SECONDS';
	END TRY
	
	BEGIN CATCH
		PRINT'==============================================================';
		PRINT'ERROR OCCURRED DURING LOADING SILVER LAYER';
		PRINT'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT'ERROR CODE: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'==============================================================';
	END CATCH
END;

