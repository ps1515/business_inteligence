from __future__ import annotations

import argparse
from datetime import date, timedelta

import pandas as pd
import requests
from sqlalchemy import create_engine, text

from settings import build_sqlalchemy_url


NBP_BASE_URL = "https://api.nbp.pl/api/exchangerates/rates/A"


def fetch_currency_rates(currency_code: str, days: int) -> pd.DataFrame:
    """
    Pobiera srednie kursy NBP dla podanej waluty z ostatnich N dni.
    API zwraca tylko dni notowan (bez weekendow i swiat).
    """
    end_date = date.today()
    start_date = end_date - timedelta(days=days)
    # API NBP ogranicza zakres jednego zapytania do 367 dni.
    records = []
    cursor = start_date
    max_window = timedelta(days=366)

    while cursor <= end_date:
        window_end = min(cursor + max_window, end_date)
        url = (
            f"{NBP_BASE_URL}/{currency_code}/"
            f"{cursor:%Y-%m-%d}/{window_end:%Y-%m-%d}/?format=json"
        )

        response = requests.get(url, timeout=30)
        response.raise_for_status()
        payload = response.json()
        rates = payload.get("rates", [])
        records.extend(
            {
                "currency_code": currency_code.upper(),
                "rate_date": pd.to_datetime(item["effectiveDate"]).date(),
                "mid_rate": float(item["mid"]),
            }
            for item in rates
        )
        cursor = window_end + timedelta(days=1)

    if not records:
        raise RuntimeError("NBP API nie zwrocilo notowan dla wskazanego zakresu.")

    return pd.DataFrame.from_records(records)


def main(currency_code: str = "USD", years: int = 4) -> None:
    days = years * 366
    rates_df = fetch_currency_rates(currency_code=currency_code, days=days)
    rates_df.sort_values("rate_date", inplace=True)

    engine = create_engine(build_sqlalchemy_url())
    with engine.begin() as connection:
        connection.execute(text("IF SCHEMA_ID('Extract') IS NULL EXEC('CREATE SCHEMA [Extract]');"))

    rates_df.to_sql(
        name="CurrencyRateData",
        con=engine,
        schema="Extract",
        if_exists="replace",
        index=False,
        chunksize=2000,
    )

    print(
        f"Loaded CurrencyRateData rows: {len(rates_df)} "
        f"for {currency_code} ({rates_df['rate_date'].min()} -> {rates_df['rate_date'].max()})"
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Load NBP currency rates to Extract.CurrencyRateData")
    parser.add_argument("--currency", default="USD", help="3-letter code, e.g. USD or EUR")
    parser.add_argument("--years", type=int, default=4, help="How many years back to fetch")
    args = parser.parse_args()
    main(currency_code=args.currency, years=args.years)
