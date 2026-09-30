--Departures only, from the five airports in scope
WITH flights AS (
    SELECT
        origin        AS airport_code,
        flight_date   AS date,
        cancelled,
        dep_delay
    FROM {{ ref('prep_flights') }}
    WHERE origin IN ('DFW', 'IAH', 'AUS', 'SAT', 'MAF')
),
-- One row per airport per day.
daily_flights AS (
    SELECT
        airport_code,
        date,
        COUNT(*)                                        AS scheduled,  --every row is a planned flight
        SUM(cancelled)                                  AS cancelled,
        ROUND(100.0 * SUM(cancelled) / COUNT(*), 1)     AS cancel_rate,
        AVG(dep_delay)                                  AS avg_delay
    FROM flights
    GROUP BY airport_code, date
),
-- daily temperature, precipitation and snow per airport.
weather AS ( 
    SELECT
        airport_code,
        date,
        min_temp_c,
        avg_temp_c,
        max_temp_c,
        precipitation_mm,
        max_snow_mm
    FROM {{ ref('prep_weather_daily') }}
)
SELECT
    f.*,
    w.min_temp_c,
    w.avg_temp_c,
    w.max_temp_c,
    w.precipitation_mm,
    w.max_snow_mm
FROM daily_flights f
LEFT JOIN weather w --a day with missing weather still appears
      ON w.airport_code = f.airport_code
      AND w.date         = f.date
ORDER BY f.airport_code, f.date