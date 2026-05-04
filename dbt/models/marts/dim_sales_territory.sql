{{ config(materialized='table') }}

select
    territory_id,
    territory_name,
    country_region_code,
    country_name,
    territory_group,
    territory_sales_ytd,
    territory_sales_last_year,
    territory_cost_ytd,
    territory_cost_last_year
from {{ ref('stg_sales_territory') }}
