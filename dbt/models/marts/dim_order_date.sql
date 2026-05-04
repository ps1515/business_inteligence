{{ config(materialized='table') }}

select
    date_key,
    order_date,
    day_of_month,
    month_number,
    month_name,
    quarter_number,
    half_year,
    calendar_year,
    weekday_name,
    weekday_number
from {{ ref('stg_order_date') }}
