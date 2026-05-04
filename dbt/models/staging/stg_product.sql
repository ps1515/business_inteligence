{{ config(materialized='view') }}

with rating as (
    select
        cast(productid as int) as product_id,
        avg(cast(ratingOverall as float)) as avg_rating,
        min(cast(ratingOverall as float)) as min_rating,
        max(cast(ratingOverall as float)) as max_rating,
        count(*) as rating_count
    from {{ source('extract', 'ProductRating') }}
    group by cast(productid as int)
),
product as (
    select
        cast(ProductID as int) as product_id,
        cast(Name as nvarchar(200)) as product_name,
        cast(ProductNumber as nvarchar(50)) as product_number,
        cast(Color as nvarchar(30)) as color,
        cast(StandardCost as decimal(18, 4)) as standard_cost,
        cast(ListPrice as decimal(18, 4)) as list_price,
        cast(Size as nvarchar(20)) as size_value,
        cast(SellStartDate as date) as sell_start_date,
        cast(SellEndDate as date) as sell_end_date,
        cast(ProductSubcategoryID as int) as product_subcategory_id,
        cast(Weight as decimal(18, 4)) as weight_value
    from {{ source('extract', 'Product') }}
),
subcategory as (
    select
        cast(ProductSubcategoryID as int) as product_subcategory_id,
        cast(Name as nvarchar(200)) as subcategory_name,
        cast(ProductCategoryID as int) as product_category_id
    from {{ source('extract', 'ProductSubcategory') }}
),
category as (
    select
        cast(ProductCategoryID as int) as product_category_id,
        cast(Name as nvarchar(200)) as category_name
    from {{ source('extract', 'ProductCategory') }}
)
select
    p.product_id,
    p.product_name,
    p.product_number,
    coalesce(p.color, 'UNKNOWN') as color,
    coalesce(p.standard_cost, 0) as standard_cost,
    coalesce(p.list_price, 0) as list_price,
    coalesce(p.size_value, 'N/A') as size_value,
    p.sell_start_date,
    p.sell_end_date,
    coalesce(s.subcategory_name, 'UNKNOWN') as subcategory_name,
    coalesce(c.category_name, 'UNKNOWN') as category_name,
    coalesce(p.weight_value, 0) as weight_value,
    coalesce(r.avg_rating, 0) as avg_rating,
    coalesce(r.min_rating, 0) as min_rating,
    coalesce(r.max_rating, 0) as max_rating,
    coalesce(r.rating_count, 0) as rating_count
from product p
left join subcategory s on p.product_subcategory_id = s.product_subcategory_id
left join category c on s.product_category_id = c.product_category_id
left join rating r on p.product_id = r.product_id
