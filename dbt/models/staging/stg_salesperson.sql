{{ config(materialized='view') }}

with sp as (
    select
        cast(BusinessEntityID as int) as salesperson_id,
        cast(TerritoryID as int) as territory_id,
        cast(SalesQuota as decimal(18, 2)) as sales_quota,
        cast(Bonus as decimal(18, 2)) as bonus,
        cast(CommissionPct as decimal(18, 4)) as commission_pct,
        cast(SalesYTD as decimal(18, 2)) as sales_ytd,
        cast(SalesLastYear as decimal(18, 2)) as sales_last_year
    from {{ source('extract', 'SalesPerson') }}
),
person as (
    select
        cast(BusinessEntityID as int) as salesperson_id,
        cast(FirstName as nvarchar(100)) as first_name,
        cast(MiddleName as nvarchar(100)) as middle_name,
        cast(LastName as nvarchar(100)) as last_name
    from {{ source('extract', 'Person') }}
)
select
    sp.salesperson_id,
    sp.territory_id,
    ltrim(rtrim(
        concat(
            coalesce(person.first_name, ''),
            ' ',
            coalesce(person.middle_name + ' ', ''),
            coalesce(person.last_name, '')
        )
    )) as salesperson_full_name,
    coalesce(sp.sales_quota, 0) as sales_quota,
    coalesce(sp.bonus, 0) as bonus,
    coalesce(sp.commission_pct, 0) as commission_pct,
    coalesce(sp.sales_ytd, 0) as sales_ytd,
    coalesce(sp.sales_last_year, 0) as sales_last_year
from sp
left join person on sp.salesperson_id = person.salesperson_id
