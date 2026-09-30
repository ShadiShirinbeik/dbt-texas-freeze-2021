WITH flights_all AS (
    SELECT * 
    FROM {{source('flights_data', 'flights')}}
)
SELECT * FROM flights_all
