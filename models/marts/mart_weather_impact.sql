{{ config(materialized='table') }}

SELECT
    flight_month,
    flight_year,
    carrier_code,
    delay_reason,
    COUNT(*)                                        AS total_flights,
    ROUND(AVG(arr_delay_min), 2)                    AS avg_delay_min,
    ROUND(AVG(weather_delay_min), 2)                AS avg_weather_delay,
    ROUND(AVG(carrier_delay_min), 2)                AS avg_carrier_delay,
    ROUND(AVG(nas_delay_min), 2)                    AS avg_nas_delay,
    COUNTIF(delay_category = 'SEVERE_DELAY')        AS severe_delays,
    ROUND(
        COUNTIF(delay_reason = 'WEATHER') * 100.0 / COUNT(*), 2
    )                                               AS weather_delay_pct,
    ROUND(
        COUNTIF(is_cancelled = TRUE) * 100.0 / COUNT(*), 2
    )                                               AS cancellation_rate
FROM {{ ref('fct_flight_delays') }}
GROUP BY flight_month, flight_year, carrier_code, delay_reason
ORDER BY flight_year, flight_month