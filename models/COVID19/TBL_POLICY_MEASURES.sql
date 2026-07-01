{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
        database='TARGET_DB',
        schema='COVID19',
        alias='TBL_POLICY_MEASURES',

        post_hook="
        call system$curl(
            'https://oxn7tku1ic.execute-api.us-east-1.amazonaws.com/prod/trigger-incident',
            'POST',
            'application/json',
            '{
                \"pipeline_name\": \"{{ this.name }}\",
                \"environment\": \"{{ target.name }}\",
                \"run_id\": \"{{ invocation_id }}\",
                \"error_message\": \"dbt model executed successfully\",
                \"variables\": {
                    \"market\": \"MX\",
                    \"load_type\": \"incremental\"
                }
            }'
        );
        "
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
