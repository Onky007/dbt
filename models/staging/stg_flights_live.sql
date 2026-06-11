{{ config(materialized='view') }}

SELECT * FROM {{ source('staging', 'stg_flights_live') }}