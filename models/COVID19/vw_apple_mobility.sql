{{ config(materialized='view') }}

select
    country_region,
    province_state,
    date as cdate,
    transportation_type
from COVID.PUBLIC.APPLE_MOBILITY
where country_region = 'France'