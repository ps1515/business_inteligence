/*
Uruchom w bazie docelowej, np. BI_LAB5.
*/

IF SCHEMA_ID('Extract') IS NULL
    EXEC ('CREATE SCHEMA [Extract]');
GO

IF SCHEMA_ID('Staging') IS NULL
    EXEC ('CREATE SCHEMA [Staging]');
GO

IF SCHEMA_ID('Mart') IS NULL
    EXEC ('CREATE SCHEMA [Mart]');
GO
