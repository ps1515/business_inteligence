{{ config(materialized='table') }}

with src as (
    select *
    from {{ ref('stg_product') }}
)
select
    product_id,
    product_name,
    product_number,
    color,
    size_value,
    category_name,
    subcategory_name,
    weight_value,
    standard_cost,
    list_price,
    sell_start_date,
    sell_end_date,
    avg_rating,
    min_rating,
    max_rating,
    rating_count,
    cast(list_price - standard_cost as decimal(18, 4)) as profit,
    cast(
        case
            when list_price = 0 then 0
            else ((list_price - standard_cost) / list_price) * 100.0
        end as decimal(18, 4)
    ) as margin_pct,
    case
        when sell_start_date is null then 'INACTIVE'
        when sell_end_date is null or sell_end_date >= cast(getdate() as date) then 'ACTIVE'
        else 'INACTIVE'
    end as active,
    case
        when sell_start_date is null then 0
        when sell_end_date is null then datediff(month, sell_start_date, cast(getdate() as date))
        else datediff(month, sell_start_date, sell_end_date)
    end as soldfor_months,
    case
        when list_price < 100 then 'LOW'
        when list_price < 300 then 'MEDIUM'
        when list_price < 500 then 'HIGH'
        else 'VERY HIGH'
    end as discreteprice
from src
