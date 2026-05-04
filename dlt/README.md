# Faza C - ekstrakcja

## Konfiguracja

1. Skopiuj `.dlt/secrets.toml.example` do `.dlt/secrets.toml`.
2. Ustaw zmienne srodowiskowe dla skryptow `pandas/sqlalchemy`:

```powershell
$env:BI_SQL_SERVER="localhost"
$env:BI_SQL_DATABASE="BI_LAB5"
$env:BI_SQL_USERNAME="sa"
$env:BI_SQL_PASSWORD="TwojeHaslo"
$env:BI_SQL_DRIVER="ODBC Driver 18 for SQL Server"
$env:BI_SQL_TRUST_CERT="yes"
$env:BI_SQL_ENCRYPT="no"
```

## Uruchomienie

```powershell
python extract_sql_to_extract.py
python load_product_rating_csv.py
python load_currency_rates_nbp.py
```

lub:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_phase_c.ps1
```

## Efekt

W bazie docelowej powstaja tabele w schemacie `Extract`:

- `Product`
- `ProductSubcategory`
- `ProductCategory`
- `SalesPerson`
- `SalesTerritory`
- `SalesOrderHeader`
- `SalesOrderDetail`
- `Person`
- `CountryRegion`
- `ProductRating`
- `CurrencyRateData`
