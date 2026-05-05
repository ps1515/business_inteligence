from __future__ import annotations

from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text

from settings import build_sqlalchemy_url


def main() -> None:
    project_root = Path(__file__).resolve().parents[1]
    csv_path = project_root.parent / "SBI2526-LAB-Rating-FixedDate.csv"

    if not csv_path.exists():
        raise FileNotFoundError(f"Nie znaleziono pliku CSV: {csv_path}")

    df = pd.read_csv(csv_path)
    df.columns = [col.strip() for col in df.columns]

    df["date"] = pd.to_datetime(df["date"], errors="coerce")
    df["date_shifted"] = df["date"] + pd.DateOffset(years=11)

    engine = create_engine(build_sqlalchemy_url())
    with engine.begin() as connection:
        connection.execute(text("IF SCHEMA_ID('Extract') IS NULL EXEC('CREATE SCHEMA [Extract]');"))

    df.to_sql(
        name="ProductRating",
        con=engine,
        schema="Extract",
        if_exists="replace",
        index=False,
        chunksize=5000,
    )

    print(f"Loaded ProductRating rows: {len(df)}")


if __name__ == "__main__":
    main()
