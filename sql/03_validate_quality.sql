/*
Propozycja testow poprawnosci i kompletnosci po Faza D/E.
*/

-- 1) Kompletność: liczba produktow po transformacji
SELECT COUNT(*) AS cnt_dim_product FROM Staging.dim_product;
SELECT COUNT(DISTINCT ProductID) AS cnt_extract_product FROM Extract.Product;
GO

-- 2) Poprawnosc kluczy i duplikatow
SELECT product_id, COUNT(*) AS c
FROM Staging.dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;
GO

SELECT date_key, COUNT(*) AS c
FROM Staging.dim_order_date
GROUP BY date_key
HAVING COUNT(*) > 1;
GO

-- 3) Poprawnosc atrybutow obliczeniowych
SELECT TOP 50 *
FROM Staging.dim_product
WHERE margin_pct < 0 OR margin_pct > 1000;
GO

SELECT TOP 50 *
FROM Staging.dim_product
WHERE discreteprice NOT IN ('LOW', 'MEDIUM', 'HIGH', 'VERY HIGH');
GO

-- 4) Integralnosc faktow do wymiarow
SELECT TOP 50 f.*
FROM Staging.fact_sales f
LEFT JOIN Staging.dim_product p ON f.product_id = p.product_id
WHERE p.product_id IS NULL;
GO

SELECT TOP 50 f.*
FROM Staging.fact_sales f
LEFT JOIN Staging.dim_order_date d ON f.date_key = d.date_key
WHERE d.date_key IS NULL;
GO

-- 5) Kursy walut i PLN
SELECT TOP 50 *
FROM Staging.fact_sales
WHERE exchange_rate_to_pln IS NULL
   OR net_amount_pln IS NULL;
GO
