-- CoffeeMerchant database developed and written by Amy Phillips
-- Originally Written: September 2005| Updated: April 2017
---------------------------------------------------------------
-- Replace <data_path> with the full path to this file 
-- Ensure it ends with a backslash. 
-- E.g., C:\MyDatabases\ See line 18
---------------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'CoffeeMerchantDM')
	CREATE DATABASE CoffeeMerchantDM
GO
USE CoffeeMerchantDM
--
-- Alter the path so the script can find the CSV files
--
DECLARE
	@data_path nvarchar(256);
SELECT @data_path = 'C:\Users\Kathryn\Documents\Graduate School\2018\Winter Quarter 2018\Data Warehousing\';
--
-- Delete existing tables
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'FactCoffeeOrders'
       )
	DROP TABLE FactCoffeeOrders;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimConsumer'
       )
	DROP TABLE DimConsumer;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimEmployee'
       )
	DROP TABLE DimEmployee;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimProduct'
       )
	DROP TABLE Product;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DimDate'
       )
	DROP TABLE DimDate;
--
-- Create tables
--
CREATE TABLE DimProduct
	(Product_SK		   INT CONSTRAINT sk_product PRIMARY KEY,
	Product_AK		   INT NOT NULL,
	ProductName		   NVARCHAR(40) NOT NULL,
	ProductDescription NVARCHAR(500) NOT NULL,
	Item Type	       NVARCHAR(5) NOT NULL,
	CountryName		   NVARCHAR(40) NOT NULL
	);
--
CREATE TABLE DimEmployee
	(Employee_SK INT CONSTRAINT sk_employee PRIMARY KEY,
	Employee_AK  INT NOT NULL,
	FirstName    NVARCHAR(30) NOT NULL,
	LastName     NVARCHAR(30) NOT NULL,
	BirthDate    DATETIME NOT NULL,
	Gender       NVARCHAR(1) NOT NULL,
	HireDate     DATETIME NOT NULL,
	);
--
CREATE TABLE DimConsumer
	(Consumer_SK	INT CONSTRAINT sk_consumer PRIMARY KEY,
	Consumer_AK		INT NOT NULL,
	City			NVARCHAR(50) NOT NULL,
	State			NVARCHAR(2)	 NOT NULL,
	Zipcode			NVARCHAR(11) NOT NULL,
	CreditLimit		INT	NOT NULL,
	);
--
CREATE TABLE DimDate
	(Date_SK	INT CONSTRAINT sk_date PRIMARY KEY,
	Day			DATETIME NOT NULL,
	Month		DATETIME NOT NULL,
	Quarter		DATETIME NOT NULL,
	Year		DATETIME NOT NULL,
	);
--
CREATE TABLE FactCoffeeOrders
	(Employee_SK		INT NOT NULL,
	Product_SK			INT NOT NULL,
	Date_SK				INT NOT NULL,
	Consumer_SK			INT NOT NULL,
	FullfillmentTime	DATETIME NOT NULL,
	AverageVolume		INT NOT NULL,
	AverageRevenue		MONEY NOT NULL,
	Quantity			INT NOT NULL,
	Price				NUMERIC(6,2) NOT NULL,
	Discount			NUMERIC(4,4) NOT NULL,
	OnHand				INT NOT NULL,
	CommissionRate		NUMERIC(4,4) NOT NULL,
	EmployeeTenure		INT NOT NULL,
	TaxRate				NUMERIC(7,4) NOT NULL,
	CONSTRAINT pk_factcoffeeorders PRIMARY KEY (Employee_SK, Product_SK, Date_SK, Consumer_SK),
	CONSTRAINT fk_factcoffeeorders_emp FOREIGN KEY (Employee_SK) REFERENCES DimEmployee(Employee_SK),
	CONSTRAINT fk_factcoffeorders_prod FOREIGN KEY (Product_SK) REFERENCES DimProduct(Product_SK),
	CONSTRAINT fk_factcoffeeorders_date FOREIGN KEY (Date_SK) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_factcoffeeorders_cons FOREIGN KEY (Consumer_SK) REFERENCES DimConsumer(Consumer_SK)
);
--
