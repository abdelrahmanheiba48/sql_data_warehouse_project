/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR  ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @START_TIME DATETIME , @END_TIME DATETIME , @PROC_START_TIME DATETIME , @PROC_END_TIME DATETIME 
	
	BEGIN TRY 
		SET @PROC_START_TIME = GETDATE();
		PRINT'===================================================';
		PRINT'Loading bronze Layer';
		PRINT'===================================================';
		PRINT'>>>> Loading crm Tables ....';
		PRINT'===================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info ;
		PRINT'>>>> Loading: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);

		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.crm_cust_info IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info ;
		PRINT'>>>> Loading: bronze.crm_prd_info';
	
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\prd_info.csv'
		WITH(
			TABLOCK,
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.crm_prd_info IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';

		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details ;
		PRINT'>>>> Loading: bronze.crm_sales_details';
	
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\sales_details.csv'
		WITH(
			TABLOCK,
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.crm_sales_details IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.erp_CUST_AZ12';
		TRUNCATE TABLE bronze.erp_CUST_AZ12 ;
		PRINT'>>>> Loading: bronze.erp_CUST_AZ12';
	
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\CUST_AZ12.csv'
		WITH(
			TABLOCK,
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.erp_CUST_AZ12 IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.erp_LOC_A101';
		TRUNCATE TABLE bronze.erp_LOC_A101 ;
		PRINT'>>>> Loading: bronze.erp_LOC_A101';
	
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\LOC_A101.csv'
		WITH(
			TABLOCK,
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.erp_LOC_A101 IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';
		SET @START_TIME = GETDATE();
		PRINT'>>>> Truncating: bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2 ;
		PRINT'>>>> Loading: bronze.erp_PX_CAT_G1V2';
	 
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\PX_CAT_G1V2.csv'
		WITH(
			TABLOCK,
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		)
		SET @END_TIME = GETDATE();
		PRINT'##LOAD DURATION FOR bronze.erp_PX_CAT_G1V2 IS'+' '+CAST(DATEDIFF(SECOND,@START_TIME , @END_TIME)AS NVARCHAR)+' '+'SECONDS' ;

		PRINT'==============================================================';
		SET @PROC_END_TIME = GETDATE();
		PRINT'==============================================================';
		PRINT'THE BRONZE LAYER LODING IS COMPLETED...';
		PRINT'THE TOTAL TIME OF THE LODING IS:'+' '+ CAST(DATEDIFF(SECOND,@PROC_START_TIME,@PROC_END_TIME) AS NVARCHAR)+' '+'SECONDS'  ;
	END TRY
	BEGIN CATCH
		PRINT'==============================================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'ERROR MESSEGE' + ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE'+CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'==============================================================';
	END CATCH
END;

EXEC bronze.load_bronze;
