param(
  [string]$CurrencyCode = "USD"
)

Write-Host "Phase C: SQL -> Extract via dlt"
python .\extract_sql_to_extract.py

Write-Host "Phase C: CSV -> Extract.ProductRating"
python .\load_product_rating_csv.py

Write-Host "Phase C: NBP API -> Extract.CurrencyRateData ($CurrencyCode)"
python .\load_currency_rates_nbp.py --currency $CurrencyCode --years 4
