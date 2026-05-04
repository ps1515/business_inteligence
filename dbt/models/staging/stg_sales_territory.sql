{{ config(materialized='view') }}

with territory as (
    select
        cast(TerritoryID as int) as territory_id,
        cast(Name as nvarchar(100)) as territory_name,
        cast(CountryRegionCode as nvarchar(10)) as country_region_code,
        cast([Group] as nvarchar(100)) as territory_group,
        cast(SalesYTD as decimal(18, 2)) as territory_sales_ytd,
        cast(SalesLastYear as decimal(18, 2)) as territory_sales_last_year,
        cast(CostYTD as decimal(18, 2)) as territory_cost_ytd,
        cast(CostLastYear as decimal(18, 2)) as territory_cost_last_year
    from {{ source('extract', 'SalesTerritory') }}
),
country as (
    select
        cast(CountryRegionCode as nvarchar(10)) as country_region_code,
        cast(Name as nvarchar(100)) as country_name
    from {{ source('extract', 'CountryRegion') }}
)
select
    t.territory_id,
    coalesce(t.territory_name, 'UNKNOWN') as territory_name,
    coalesce(t.country_region_code, 'N/A') as country_region_code,
    coalesce(c.country_name, 'UNKNOWN') as country_name,
    coalesce(t.territory_group, 'UNKNOWN') as territory_group,
    coalesce(t.territory_sales_ytd, 0) as territory_sales_ytd,
    coalesce(t.territory_sales_last_year, 0) as territory_sales_last_year,
    coalesce(t.territory_cost_ytd, 0) as territory_cost_ytd,
    coalesce(t.territory_cost_last_year, 0) as territory_cost_last_year
from territory t
left join country c on t.country_region_code = c.country_region_code
