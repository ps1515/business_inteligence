{{ config(materialized='view') }}

with h as (
    select
        cast(SalesOrderID as int) as sales_order_id,
        cast(SalesPersonID as int) as salesperson_id,
        cast(TerritoryID as int) as territory_id,
        cast(dateadd(year, 11, cast(OrderDate as date)) as date) as order_date,
        cast(SubTotal as decimal(18, 2)) as order_subtotal,
        cast(TaxAmt as decimal(18, 2)) as order_tax_amount,
        cast(Freight as decimal(18, 2)) as order_freight
    from {{ source('extract', 'SalesOrderHeader') }}
),
d as (
    select
        cast(SalesOrderID as int) as sales_order_id,
        cast(SalesOrderDetailID as int) as sales_order_detail_id,
        cast(ProductID as int) as product_id,
        cast(OrderQty as int) as order_qty,
        cast(UnitPrice as decimal(18, 4)) as unit_price,
        cast(UnitPriceDiscount as decimal(18, 4)) as unit_price_discount,
        cast(LineTotal as decimal(18, 4)) as line_total
    from {{ source('extract', 'SalesOrderDetail') }}
)
select
    d.sales_order_detail_id as sales_key,
    d.sales_order_id,
    d.product_id,
    h.salesperson_id,
    h.territory_id,
    h.order_date,
    cast(format(h.order_date, 'yyyyMMdd') as int) as date_key,
    d.order_qty,
    d.unit_price,
    d.unit_price_discount,
    d.line_total,
    cast(d.unit_price * d.order_qty as decimal(18, 4)) as gross_amount,
    cast(d.unit_price * d.order_qty * d.unit_price_discount as decimal(18, 4)) as discount_amount
from d
inner join h on d.sales_order_id = h.sales_order_id
