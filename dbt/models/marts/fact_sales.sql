{{ config(materialized='table') }}

with sales as (
    select *
    from {{ ref('stg_sales') }}
),
product as (
    select
        product_id,
        standard_cost
    from {{ ref('dim_product') }}
),
rates as (
    select
        rate_date,
        currency_code,
        mid_rate,
        lag(mid_rate) over (partition by currency_code order by rate_date) as prev_mid_rate
    from {{ ref('stg_currency_rate_filled') }}
)
select
    s.sales_key,
    s.sales_order_id,
    s.product_id,
    coalesce(s.salesperson_id, -1) as salesperson_id,
    coalesce(s.territory_id, -1) as territory_id,
    s.date_key,
    s.order_date,
    s.order_qty,
    s.unit_price,
    s.unit_price_discount,
    s.gross_amount as sales_amount_usd,
    s.discount_amount as discount_amount_usd,
    s.line_total as net_amount_usd,
    cast(coalesce(p.standard_cost, 0) * s.order_qty as decimal(18, 4)) as cost_amount_usd,
    cast(s.line_total - (coalesce(p.standard_cost, 0) * s.order_qty) as decimal(18, 4)) as profit_amount_usd,
    r.currency_code as currency_code_to_pln,
    r.mid_rate as exchange_rate_to_pln,
    cast(s.line_total * r.mid_rate as decimal(18, 4)) as net_amount_pln,
    cast((s.line_total - (coalesce(p.standard_cost, 0) * s.order_qty)) * r.mid_rate as decimal(18, 4)) as profit_amount_pln,
    case
        when r.prev_mid_rate is null then 'NO_DATA'
        when r.mid_rate > r.prev_mid_rate then 'UP'
        when r.mid_rate < r.prev_mid_rate then 'DOWN'
        else 'FLAT'
    end as exchange_rate_trend
from sales s
left join product p on s.product_id = p.product_id
left join rates r on s.order_date = r.rate_date and r.currency_code = 'USD'
