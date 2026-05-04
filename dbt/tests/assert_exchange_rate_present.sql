select
    sales_key,
    order_date
from {{ ref('fact_sales') }}
where exchange_rate_to_pln is null
