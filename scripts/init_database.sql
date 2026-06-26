/*
===============================
Create Database and Schemas
===============================
Script Purpose :
	Create the new Database and 3 Schemas --> gold,silver and bronze


*/
USE master;	

CREATE DATABASE DataWarehouse;
USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold ;
