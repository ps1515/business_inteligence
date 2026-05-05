from __future__ import annotations

import dlt
from dlt.sources.sql_database import sql_database


def run_extract_load() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="aw_to_extract",
        destination="mssql",
        dataset_name="Extract",
    )

    resources = [
        ("Production", "Product"),
        ("Production", "ProductSubcategory"),
        ("Production", "ProductCategory"),
        ("Sales", "SalesPerson"),
        ("Sales", "SalesTerritory"),
        ("Sales", "SalesOrderHeader"),
        ("Sales", "SalesOrderDetail"),
        ("Person", "Person"),
        ("Person", "CountryRegion"),
    ]

    for schema_name, table_name in resources:
        source = sql_database(schema=schema_name).with_resources(table_name)
        load_info = pipeline.run(source, write_disposition="replace")
        print(f"Loaded {schema_name}.{table_name}")
        print(load_info)


if __name__ == "__main__":
    run_extract_load()
