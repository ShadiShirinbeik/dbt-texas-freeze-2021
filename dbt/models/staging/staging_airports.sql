WITH airports_regions_join AS (
        SELECT * 
        FROM {{source('flights_data', 'airports')}}
        LEFT JOIN {{source('flights_data', 'regions')}}
        USING (country)
    )
    SELECT * FROM airports_regions_join