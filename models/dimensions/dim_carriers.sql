{{ config(materialized='table') }}

SELECT DISTINCT
    carrier_code,
    COUNT(*)                                        AS total_flights,
    ROUND(AVG(arr_delay_min), 2)                    AS avg_delay_min,
    COUNTIF(is_cancelled = TRUE)                    AS total_cancellations,
    COUNTIF(delay_category = 'ON_TIME')             AS total_ontime,
    ROUND(
        COUNTIF(delay_category = 'ON_TIME') * 100.0 / COUNT(*), 2
    )                                               AS ontime_pct
FROM {{ ref('stg_flights_historical') }}
GROUP BY carrier_code