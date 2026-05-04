/*
Fallback ekstrakcji "as-is" z lokalnego AdventureWorks2014 do Lab5_BI.Extract.
Uruchamiac na serwerze lokalnym SQL Server.
*/

USE Lab5_BI;
GO

IF SCHEMA_ID('Extract') IS NULL
    EXEC ('CREATE SCHEMA [Extract]');
GO

DROP TABLE IF EXISTS Extract.Product;
SELECT *
INTO Extract.Product
FROM AdventureWorks2014.Production.Product;
GO

DROP TABLE IF EXISTS Extract.ProductSubcategory;
SELECT *
INTO Extract.ProductSubcategory
FROM AdventureWorks2014.Production.ProductSubcategory;
GO

DROP TABLE IF EXISTS Extract.ProductCategory;
SELECT *
INTO Extract.ProductCategory
FROM AdventureWorks2014.Production.ProductCategory;
GO

DROP TABLE IF EXISTS Extract.SalesPerson;
SELECT *
INTO Extract.SalesPerson
FROM AdventureWorks2014.Sales.SalesPerson;
GO

DROP TABLE IF EXISTS Extract.SalesTerritory;
SELECT *
INTO Extract.SalesTerritory
FROM AdventureWorks2014.Sales.SalesTerritory;
GO

DROP TABLE IF EXISTS Extract.Person;
SELECT *
INTO Extract.Person
FROM AdventureWorks2014.Person.Person;
GO

DROP TABLE IF EXISTS Extract.CountryRegion;
SELECT *
INTO Extract.CountryRegion
FROM AdventureWorks2014.Person.CountryRegion;
GO

DROP TABLE IF EXISTS Extract.SalesOrderHeader;
SELECT *
INTO Extract.SalesOrderHeader
FROM AdventureWorks2014.Sales.SalesOrderHeader;
GO

DROP TABLE IF EXISTS Extract.SalesOrderDetail;
SELECT *
INTO Extract.SalesOrderDetail
FROM AdventureWorks2014.Sales.SalesOrderDetail;
GO
