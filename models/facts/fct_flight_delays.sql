{{ config(
    materialized='table',
    partition_by={
      "field": "flight_date",
      "data_type": "date"
    }
) }}

SELECT
    flight_date,
    carrier_code,
    flight_number,
    origin_airport,
    dest_airport,
    dep_delay_min,
    arr_delay_min,
    distance_miles,
    air_time_min,
    carrier_delay_min,
    weather_delay_min,
    nas_delay_min,
    is_cancelled,
    cancellation_reason,
    delay_category,
    delay_reason,
    flight_year,
    flight_month,
    day_of_week,
    is_weekend,
    processed_at
FROM {{ ref('stg_flights_historical') }}
WHERE flight_date IS NOT NULL