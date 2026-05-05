IF OBJECT_ID('Staging.DimProduct', 'U') IS NOT NULL DROP TABLE Staging.DimProduct;
IF OBJECT_ID('Staging.DimSalesperson', 'U') IS NOT NULL DROP TABLE Staging.DimSalesperson;
IF OBJECT_ID('Staging.DimSalesTerritory', 'U') IS NOT NULL DROP TABLE Staging.DimSalesTerritory;
IF OBJECT_ID('Staging.DimOrderDate', 'U') IS NOT NULL DROP TABLE Staging.DimOrderDate;
IF OBJECT_ID('Staging.FactSales', 'U') IS NOT NULL DROP TABLE Staging.FactSales;
GO

CREATE TABLE Staging.DimProduct
(
    ProductID           INT           NOT NULL PRIMARY KEY,
    ProductName         NVARCHAR(200) NOT NULL,
    ProductNumber       NVARCHAR(50)  NOT NULL,
    CategoryName        NVARCHAR(200) NOT NULL,
    SubcategoryName     NVARCHAR(200) NOT NULL,
    StandardCost        DECIMAL(18,4) NOT NULL,
    ListPrice           DECIMAL(18,4) NOT NULL,
    Profit              DECIMAL(18,4) NOT NULL,
    MarginPct           DECIMAL(18,4) NOT NULL,
    Active              NVARCHAR(10)  NOT NULL,
    SoldForMonths       INT           NOT NULL,
    DiscretePrice       NVARCHAR(20)  NOT NULL,
    AvgRating           DECIMAL(18,4) NOT NULL,
    MinRating           DECIMAL(18,4) NOT NULL,
    MaxRating           DECIMAL(18,4) NOT NULL,
    RatingCount         INT           NOT NULL
);
GO

CREATE TABLE Staging.DimSalesperson
(
    SalespersonID         INT           NOT NULL PRIMARY KEY,
    SalespersonFullName   NVARCHAR(300) NOT NULL,
    TerritoryID           INT           NULL,
    TerritoryName         NVARCHAR(100) NULL,
    CountryRegionCode     NVARCHAR(10)  NULL,
    CountryName           NVARCHAR(100) NULL,
    TerritoryGroup        NVARCHAR(100) NULL
);
GO

CREATE TABLE Staging.DimSalesTerritory
(
    TerritoryID             INT           NOT NULL PRIMARY KEY,
    TerritoryName           NVARCHAR(100) NOT NULL,
    CountryRegionCode       NVARCHAR(10)  NOT NULL,
    CountryName             NVARCHAR(100) NOT NULL,
    TerritoryGroup          NVARCHAR(100) NOT NULL,
    TerritorySalesYTD       DECIMAL(18,2) NOT NULL,
    TerritorySalesLastYear  DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE Staging.DimOrderDate
(
    DateKey        INT           NOT NULL PRIMARY KEY,
    OrderDate      DATE          NOT NULL UNIQUE,
    DayOfMonth     TINYINT       NOT NULL,
    MonthNumber    TINYINT       NOT NULL,
    MonthName      NVARCHAR(20)  NOT NULL,
    QuarterNumber  TINYINT       NOT NULL,
    HalfYear       TINYINT       NOT NULL,
    CalendarYear   SMALLINT      NOT NULL
);
GO

CREATE TABLE Staging.FactSales
(
    SalesKey             INT            NOT NULL PRIMARY KEY,
    SalesOrderID         INT            NOT NULL,
    ProductID            INT            NOT NULL,
    SalespersonID        INT            NOT NULL,
    TerritoryID          INT            NOT NULL,
    DateKey              INT            NOT NULL,
    OrderQty             INT            NOT NULL,
    SalesAmountUSD       DECIMAL(18,4)  NOT NULL,
    NetAmountUSD         DECIMAL(18,4)  NOT NULL,
    ProfitAmountUSD      DECIMAL(18,4)  NOT NULL,
    ExchangeRateToPLN    DECIMAL(18,6)  NOT NULL,
    NetAmountPLN         DECIMAL(18,4)  NOT NULL,
    ProfitAmountPLN      DECIMAL(18,4)  NOT NULL,
    ExchangeRateTrend    NVARCHAR(10)   NOT NULL,
    CONSTRAINT FK_FactSales_DimProduct
        FOREIGN KEY (ProductID) REFERENCES Staging.DimProduct(ProductID),
    CONSTRAINT FK_FactSales_DimSalesperson
        FOREIGN KEY (SalespersonID) REFERENCES Staging.DimSalesperson(SalespersonID),
    CONSTRAINT FK_FactSales_DimSalesTerritory
        FOREIGN KEY (TerritoryID) REFERENCES Staging.DimSalesTerritory(TerritoryID),
    CONSTRAINT FK_FactSales_DimOrderDate
        FOREIGN KEY (DateKey) REFERENCES Staging.DimOrderDate(DateKey)
);
GO
