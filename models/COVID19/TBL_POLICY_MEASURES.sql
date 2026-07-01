{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
        database='TARGET_DB',
        schema='COVID19',
        alias='TBL_POLICY_MEASURES'
    )
}}
 
SELECT
    STATE_ID,
    COUNTY,
    FIPS_CODE,
    POLICY_LEVEL,
    POLICY_TYPE,
    START_STOP,
    COMMENTS,
    TOTAL_PHASE,
    LAST_UPDATE_DATE,
    LAST_REPORTED_FLAG,
    CURRENT_TIMESTAMP() AS ETL_LOADDATETIME
FROM COVID.PUBLIC.CDC_POLICY_MEASURES