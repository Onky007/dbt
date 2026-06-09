{{ config(materialized='table') }}

SELECT
    origin_airport                          AS airport_code,
    COUNT(*)                                AS total_departures,
    ROUND(AVG(dep_delay_min), 2)            AS avg_dep_delay,
    ROUND(AVG(distance_miles), 0)           AS avg_route_distance,
    COUNTIF(is_cancelled = TRUE)            AS total_cancellations,
    COUNTIF(delay_category = 'SEVERE_DELAY') AS severe_delays
FROM {{ ref('stg_flights_historical') }}
GROUP BY origin_airport