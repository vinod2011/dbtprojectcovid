{{ config(
    materialized = 'view'
) }}

select
    country_region,
    province_state,
    date as cdate,
    transportation_type
from COVID.COVID19.APPLE_MOBILITY
where country_region = 'France'