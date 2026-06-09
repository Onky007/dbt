{{ config(materialized='table') }}

SELECT
    origin_airport,
    dest_airport,
    carrier_code,
    COUNT(*)                                        AS total_flights,
    ROUND(AVG(arr_delay_min), 2)                    AS avg_arr_delay,
    ROUND(AVG(dep_delay_min), 2)                    AS avg_dep_delay,
    ROUND(AVG(distance_miles), 0)                   AS avg_distance_miles,
    COUNTIF(delay_category = 'ON_TIME')             AS ontime_count,
    COUNTIF(delay_category = 'SEVERE_DELAY')        AS severe_count,
    COUNTIF(is_cancelled = TRUE)                    AS cancelled_count,
    ROUND(
        COUNTIF(delay_category = 'ON_TIME') * 100.0 / COUNT(*), 2
    )                                               AS ontime_pct,
    ROUND(AVG(air_time_min), 0)                     AS avg_air_time_min
FROM {{ ref('fct_flight_delays') }}
GROUP BY origin_airport, dest_airport, carrier_code
ORDER BY total_flights DESC