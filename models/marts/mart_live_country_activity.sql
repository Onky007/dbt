{{ config(materialized='table') }}

SELECT
    origin_country,
    COUNT(*)                                        AS total_live_flights,
    ROUND(AVG(speed_kmh), 2)                        AS avg_speed_kmh,
    ROUND(AVG(altitude_ft), 0)                      AS avg_altitude_ft,
    COUNTIF(flight_phase = 'CRUISING')              AS cruising_flights,
    COUNTIF(flight_phase = 'TAKEOFF_LANDING')       AS takeoff_landing_flights,
    COUNTIF(speed_category = 'FAST')                AS fast_flights,
    ROUND(
        COUNTIF(flight_phase = 'CRUISING') * 100.0 / COUNT(*), 2
    )                                               AS cruising_pct,
    MAX(ingested_at)                                AS last_updated
FROM {{ ref('fct_live_flights') }}
GROUP BY origin_country
ORDER BY total_live_flights DESC