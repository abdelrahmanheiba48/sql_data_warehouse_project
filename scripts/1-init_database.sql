-- ============================================
-- Create Database: DataWarehouse
-- ============================================
-- Purpose:    Drops and recreates the DataWarehouse database
-- Warning:    All existing data will be lost!
-- ============================================

USE master;	
IF EXISTS (SELECT 1 FROM SYS.databases WHERE name = 'DataWarehouse')
BEGIN
	PRINT 'Database exists. Dropping...';
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMDIATE;
	DROP DATABASE DataWarehouse;
	PRINT 'Database dropped successfully.';
END;

CREATE DATABASE DataWarehouse;
USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold ;
