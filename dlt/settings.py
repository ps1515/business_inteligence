from __future__ import annotations

import os
from urllib.parse import quote_plus


def build_sqlalchemy_url() -> str:
    server = os.getenv("BI_SQL_SERVER", "localhost")
    database = os.getenv("BI_SQL_DATABASE", "Lab5_BI")
    username = os.getenv("BI_SQL_USERNAME", "")
    password = os.getenv("BI_SQL_PASSWORD", "")
    driver = os.getenv("BI_SQL_DRIVER", "ODBC Driver 18 for SQL Server")
    trust_server_certificate = os.getenv("BI_SQL_TRUST_CERT", "yes")
    encrypt = os.getenv("BI_SQL_ENCRYPT", "no")
    trusted_connection = os.getenv("BI_SQL_TRUSTED_CONNECTION", "yes")

    base = (
        f"DRIVER={driver};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"TrustServerCertificate={trust_server_certificate};"
        f"Encrypt={encrypt};"
    )
    if username and password:
        auth = f"UID={username};PWD={password};"
    else:
        auth = f"Trusted_Connection={trusted_connection};"

    params = quote_plus(base + auth)
    return f"mssql+pyodbc:///?odbc_connect={params}"
