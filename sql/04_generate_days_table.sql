DECLARE @start_date date = (
    SELECT MIN(CAST(DATEADD(year, 11, OrderDate) AS date))
    FROM Extract.SalesOrderHeader
);

DECLARE @end_date date = (
    SELECT MAX(CAST(DATEADD(year, 11, OrderDate) AS date))
    FROM Extract.SalesOrderHeader
);

IF OBJECT_ID('Staging.Days', 'U') IS NOT NULL
    DROP TABLE Staging.Days;

WITH D(ID) AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY SalesOrderID)
    FROM Extract.SalesOrderHeader
)
SELECT DATEADD(day, D.ID - 1, @start_date) AS DID
INTO Staging.Days
FROM D
WHERE DATEADD(day, D.ID - 1, @start_date) <= @end_date;
