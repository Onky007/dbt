{{ config(materialized='table') }}

SELECT DISTINCT
    flight_date                                         AS date_day,
    EXTRACT(YEAR FROM flight_date)                      AS year,
    EXTRACT(MONTH FROM flight_date)                     AS month,
    EXTRACT(DAY FROM flight_date)                       AS day,
    FORMAT_DATE('%A', flight_date)                      AS day_name,
    FORMAT_DATE('%B', flight_date)                      AS month_name,
    EXTRACT(QUARTER FROM flight_date)                   AS quarter,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM flight_date) IN (1,7)
        THEN TRUE ELSE FALSE
    END                                                 AS is_weekend,
    CASE
        WHEN EXTRACT(MONTH FROM flight_date) IN (6,7,8)   THEN 'SUMMER'
        WHEN EXTRACT(MONTH FROM flight_date) IN (12,1,2)  THEN 'WINTER'
        WHEN EXTRACT(MONTH FROM flight_date) IN (3,4,5)   THEN 'SPRING'
        ELSE 'FALL'
    END                                                 AS season
FROM {{ ref('stg_flights_historical') }}
ORDER BY date_day