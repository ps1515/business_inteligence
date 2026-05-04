select
    sales_key,
    sales_amount_usd,
    net_amount_usd
from {{ ref('fact_sales') }}
where sales_amount_usd < 0
   or net_amount_usd < 0
