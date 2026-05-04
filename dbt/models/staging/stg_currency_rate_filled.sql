{{ config(materialized='view') }}

with raw_rates as (
    select
        cast(rate_date as date) as rate_date,
        upper(cast(currency_code as nvarchar(3))) as currency_code,
        cast(mid_rate as decimal(18, 6)) as mid_rate
    from {{ source('extract', 'CurrencyRateData') }}
),
calendar as (
    select order_date
    from {{ ref('stg_order_date') }}
)
select
    c.order_date as rate_date,
    r.currency_code,
    r.mid_rate
from calendar c
outer apply (
    select top 1
        rr.currency_code,
        rr.mid_rate
    from raw_rates rr
    where rr.rate_date <= c.order_date
    order by rr.rate_date desc
) r
where r.mid_rate is not null
