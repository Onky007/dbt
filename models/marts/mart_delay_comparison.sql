{{ config(materialized='table') }}

WITH historical_summary AS (
    SELECT
        carrier_code,
        COUNT(*)                                    AS total_historical_flights,
        ROUND(AVG(arr_delay_min), 2)                AS avg_arr_delay_min,
        ROUND(AVG(dep_delay_min), 2)                AS avg_dep_delay_min,
        COUNTIF(delay_category = 'ON_TIME')         AS ontime_flights,
        COUNTIF(delay_category = 'SEVERE_DELAY')    AS severe_delay_flights,
        COUNTIF(is_cancelled = TRUE)                AS cancelled_flights,
        ROUND(
            COUNTIF(delay_category = 'ON_TIME') * 100.0 / COUNT(*), 2
        )                                           AS ontime_pct,
        MAX(flight_date)                            AS latest_flight_date
    FROM {{ ref('fct_flight_delays') }}
    GROUP BY carrier_code
),

live_summary AS (
    SELECT
        carrier_code,
        COUNT(*)                                    AS total_live_flights,
        ROUND(AVG(speed_kmh), 2)                    AS avg_speed_kmh,
        ROUND(AVG(altitude_ft), 0)                  AS avg_altitude_ft,
        COUNTIF(flight_phase = 'CRUISING')          AS cruising_count,
        COUNTIF(flight_phase = 'TAKEOFF_LANDING')   AS takeoff_landing_count,
        MAX(ingested_at)                            AS last_seen_at
    FROM {{ ref('fct_live_flights') }}
    GROUP BY carrier_code
)

SELECT
    h.carrier_code,
    h.total_historical_flights,
    h.avg_arr_delay_min,
    h.avg_dep_delay_min,
    h.ontime_pct,
    h.severe_delay_flights,
    h.cancelled_flights,
    h.latest_flight_date,
    l.total_live_flights,
    l.avg_speed_kmh,
    l.avg_altitude_ft,
    l.cruising_count,
    l.last_seen_at,
    CASE
        WHEN h.ontime_pct >= 80 THEN 'RELIABLE'
        WHEN h.ontime_pct >= 60 THEN 'AVERAGE'
        ELSE 'UNRELIABLE'
    END                                             AS carrier_reliability,
    CURRENT_TIMESTAMP()                             AS mart_updated_at
FROM historical_summary h
LEFT JOIN live_summary l
    ON h.carrier_code = l.carrier_code
ORDER BY h.avg_arr_delay_min DESC