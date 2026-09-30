WITH date_parts AS (
    SELECT     
            *, 
            TO_CHAR(date, 'MM-DD') AS monthday,
            DATE_PART('day', date) AS date_day,
            DATE_PART('month', date) AS date_month,
            DATE_PART('year', date) AS date_year,
            DATE_PART('week', date) AS cw,
            TO_CHAR(date, 'FMMonth') AS month_name,
            TO_CHAR(date, 'FMDay') AS weekday
    FROM {{ref('staging_weather_daily')}}
),
add_seasons AS (
    SELECT *,
            (CASE 
                WHEN month_name IN ('November', 'December', 'January', 'February')
                THEN 'winter'
                WHEN month_name IN ('March', 'April', 'May') THEN 'spring'
                WHEN month_name IN ('June', 'July', 'August') THEN 'sommer'
                WHEN month_name IN ('September', 'October') THEN 'autumn'
            END) AS season
    FROM date_parts
)
SELECT * FROM add_seasons