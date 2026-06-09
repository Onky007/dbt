{{ config(materialized='table') }}

SELECT
    ingested_date,
    ingested_hour,
    carrier_code,
    callsign,
    flight_number_live,
    origin_country,
    longitude,
    latitude,
    altitude_m,
    altitude_ft,
    velocity_ms,
    speed_kmh,
    flight_phase,
    speed_category,
    on_ground,
    ingested_at,
    processed_at
FROM {{ ref('stg_flights_live') }}
WHERE carrier_code IS NOT NULL