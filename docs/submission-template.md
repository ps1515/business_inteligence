# Szablon opisu do oddania

## Zadanie 2 - Ekstrakcja (dlt)

- Utworzono baze docelowa: `BI_LAB5`.
- Utworzono schemat: `Extract`.
- Zrealizowano ekstrakcje tabel z AdventureWorks do `Extract` przy pomocy `dlt`.
- Zaladowano plik ocen do `Extract.ProductRating`.
- Pobieranie kursow NBP z API zapisano do `Extract.CurrencyRateData`.

Pliki:

- `dlt/extract_sql_to_extract.py`
- `dlt/load_product_rating_csv.py`
- `dlt/load_currency_rates_nbp.py`

## Zadanie 3 - Transformacje (dbt + SQL)

- Zdefiniowano modele staging i marts.
- Utworzono model gwiazdy: 4 wymiary + fakt.
- Dodano atrybuty obliczeniowe produktu (`profit`, `margin_pct`, `active`, `soldfor_months`, `discreteprice`).
- Dodano przeliczenie PLN i trend kursu w fakcie.

Pliki:

- `dbt/models/staging/*`
- `dbt/models/marts/*`
- `dbt/tests/*`
- `sql/02_create_empty_star_tables.sql`

## Zadanie 4 - Wstepne ladowanie

- Ladowanie finalnych struktur realizowane przez `dbt run`.
- Walidacje: `dbt test` oraz `sql/03_validate_quality.sql`.

## Zadanie 5 - Wizualizacja

- Raport wykonany w Power BI Desktop, polaczenie `DirectQuery`.
- Wizualizacja 1: suma USD i PLN.
- Wizualizacja 2: sprzedaz vs trend kursu.
