# Faza F - checklista raportu Power BI

## Polaczenie

- [ ] Zrodlo: SQL Server (lub DuckDB w wersji rozszerzonej).
- [ ] Tryb: `DirectQuery`.
- [ ] Tabele: `dim_product`, `dim_salesperson`, `dim_sales_territory`, `dim_order_date`, `fact_sales`.
- [ ] Relacje ustawione zgodnie z kluczami obcymi.

## Wizualizacja 1: sprzedaz USD vs PLN

- [ ] Wykres liniowy lub kolumnowy.
- [ ] OX: data (`dim_order_date.order_date` lub rok/miesiac).
- [ ] OY (2 serie):
  - `SUM(fact_sales.net_amount_usd)`
  - `SUM(fact_sales.net_amount_pln)`
- [ ] Zakres czasu: minimum 2 lata.
- [ ] Tytul, legenda, podpis osi.

## Wizualizacja 2: sprzedaz vs trend kursu

- [ ] Wykres kolumnowy skumulowany lub clustered.
- [ ] OX: data (np. miesiac).
- [ ] Seria/legenda: `exchange_rate_trend` (`UP`, `DOWN`, `FLAT`).
- [ ] OY: `SUM(fact_sales.net_amount_usd)` lub `SUM(fact_sales.net_amount_pln)`.
- [ ] Filtr: minimum 2 lata.
- [ ] Tytul, legenda, podpis osi.

## Dodatkowe elementy

- [ ] Slicer dla roku/miesiaca.
- [ ] Slicer dla terytorium/sprzedawcy.
- [ ] Karta KPI (suma sprzedazy PLN).
