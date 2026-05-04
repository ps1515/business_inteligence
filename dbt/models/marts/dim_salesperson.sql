{{ config(materialized='table') }}

with sp as (
    select *
    from {{ ref('stg_salesperson') }}
),
ter as (
    select *
    from {{ ref('stg_sales_territory') }}
)
select
    sp.salesperson_id,
    sp.salesperson_full_name,
    sp.sales_quota,
    sp.bonus,
    sp.commission_pct,
    sp.sales_ytd,
    sp.sales_last_year,
    ter.territory_id,
    ter.territory_name,
    ter.country_region_code,
    ter.country_name,
    ter.territory_group
from sp
left join ter on sp.territory_id = ter.territory_id
