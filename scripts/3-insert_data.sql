TRUNCATE TABLE bronze.crm_cust_info ;
Go
BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\cust_info.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',' ,
	TABLOCK
);
Go
TRUNCATE TABLE bronze.crm_prd_info;
Go
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\prd_info.csv'
WITH(
	TABLOCK,
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
);
GO
TRUNCATE TABLE bronze.crm_sales_details ;
GO
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\Sources_crm\sales_details.csv'
WITH(
	TABLOCK,
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
);
GO
TRUNCATE TABLE bronze.erp_CUST_AZ12;
GO
BULK INSERT bronze.erp_CUST_AZ12
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\CUST_AZ12.csv'
WITH(
	TABLOCK,
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
);
TRUNCATE TABLE bronze.erp_LOC_A101;
GO
BULK INSERT bronze.erp_LOC_A101
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\LOC_A101.csv'
WITH(
	TABLOCK,
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
);
GO
TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
GO 
BULK INSERT bronze.erp_PX_CAT_G1V2
FROM 'C:\Users\Abdu\Desktop\Projects\SQL_Projects\DATA _WAREHOUSE\datasets\sources_erp\PX_CAT_G1V2.csv'
WITH(
	TABLOCK,
	FIRSTROW = 2,
	FIELDTERMINATOR = ','
);
