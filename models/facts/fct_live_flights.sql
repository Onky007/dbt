{{ config(materialized='table') }}

SELECT
    carrier_code,
    callsign,
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
    processed_at,
    DATE(ingested_at)           AS ingested_date,
    EXTRACT(HOUR FROM ingested_at) AS ingested_hour

FROM {{ ref('stg_flights_live') }}
WHERE carrier_code IS NOT NULL