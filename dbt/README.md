# Faza D - dbt transformacje

## Konfiguracja

1. Skopiuj `profiles.yml.example` do `%USERPROFILE%/.dbt/profiles.yml`.
2. Uzupelnij host, baze i dane logowania.

## Uruchomienie

```powershell
dbt debug --project-dir .\dbt
dbt run --project-dir .\dbt
dbt test --project-dir .\dbt
```

## Co powstaje

- Widoki staging:
  - `stg_product`
  - `stg_salesperson`
  - `stg_sales_territory`
  - `stg_order_date`
  - `stg_currency_rate_filled`
  - `stg_sales`
- Tabele marts:
  - `dim_product`
  - `dim_salesperson`
  - `dim_sales_territory`
  - `dim_order_date`
  - `fact_sales`
