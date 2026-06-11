{{ config(
    materialized='table',
    partition_by={
      "field": "flight_date",
      "data_type": "date",
      "granularity": "month"
    }
) }}

SELECT
    SAFE.PARSE_DATE('%Y-%m-%d', CAST(flight_date AS STRING))    AS flight_date,
    carrier_code,
    flight_number,
    origin_airport,
    dest_airport,
    SAFE_CAST(dep_delay_min AS FLOAT64)                         AS dep_delay_min,
    SAFE_CAST(arr_delay_min AS FLOAT64)                         AS arr_delay_min,
    SAFE_CAST(distance_miles AS FLOAT64)                        AS distance_miles,
    SAFE_CAST(air_time_min AS FLOAT64)                          AS air_time_min,
    SAFE_CAST(carrier_delay_min AS FLOAT64)                     AS carrier_delay_min,
    SAFE_CAST(weather_delay_min AS FLOAT64)                     AS weather_delay_min,
    SAFE_CAST(nas_delay_min AS FLOAT64)                         AS nas_delay_min,
    SAFE_CAST(is_cancelled AS FLOAT64)                          AS is_cancelled,
    delay_category,
    delay_reason,

    EXTRACT(YEAR FROM
        SAFE.PARSE_DATE('%Y-%m-%d', CAST(flight_date AS STRING)))   AS flight_year,
    EXTRACT(MONTH FROM
        SAFE.PARSE_DATE('%Y-%m-%d', CAST(flight_date AS STRING)))   AS flight_month,
    EXTRACT(DAYOFWEEK FROM
        SAFE.PARSE_DATE('%Y-%m-%d', CAST(flight_date AS STRING)))   AS day_of_week,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM
            SAFE.PARSE_DATE('%Y-%m-%d', CAST(flight_date AS STRING))) IN (1,7)
        THEN TRUE ELSE FALSE
    END                                                             AS is_weekend,

    processed_at

FROM {{ ref('stg_flights_historical') }}
WHERE flight_date IS NOT NULL