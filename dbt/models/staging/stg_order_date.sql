{{ config(materialized='view') }}

with sales_dates as (
    select
        cast(dateadd(year, 11, cast(OrderDate as date)) as date) as order_date
    from {{ source('extract', 'SalesOrderHeader') }}
),
bounds as (
    select
        min(order_date) as min_order_date,
        max(order_date) as max_order_date
    from sales_dates
),
numbers as (
    select top (
        select datediff(day, min_order_date, max_order_date) + 1
        from bounds
    )
        row_number() over (order by (select null)) - 1 as day_offset
    from sys.all_objects a
    cross join sys.all_objects b
),
calendar as (
    select
        dateadd(day, n.day_offset, b.min_order_date) as date_value
    from numbers n
    cross join bounds b
)
select
    cast(format(date_value, 'yyyyMMdd') as int) as date_key,
    cast(date_value as date) as order_date,
    day(date_value) as day_of_month,
    month(date_value) as month_number,
    datename(month, date_value) as month_name,
    datepart(quarter, date_value) as quarter_number,
    case
        when month(date_value) between 1 and 6 then 1
        else 2
    end as half_year,
    year(date_value) as calendar_year,
    datename(weekday, date_value) as weekday_name,
    datepart(weekday, date_value) as weekday_number
from calendar
