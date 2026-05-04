# Faza E - wstepne ladowanie danych

## Wersja podstawowa (SQL Server)

1. Upewnij sie, ze Faza C jest zakonczona (dane sa w `Extract`).
2. Uruchom dbt:
   - `dbt run --project-dir dbt`
3. Wynik:
   - dane gotowe do analizy w tabelach `Staging.dim_*` i `Staging.fact_sales`.

## Wersja rozszerzona (DuckDB, opcjonalnie)

1. Zainstaluj dodatki:
   - `pip install dlt[duckdb] duckdb`
2. W `dlt/.dlt/secrets.toml` skonfiguruj:
   - `[destination.duckdb.credentials]`
3. Wykonaj eksport do DuckDB przez dlt (mozna skopiowac dane ze schematu `Staging`):
   - pipeline `destination="duckdb"`
   - `dataset_name="gold_zone"`

## Kontrola po ladowaniu

Uruchom:

- `sql/03_validate_quality.sql`
- `dbt test --project-dir dbt`
