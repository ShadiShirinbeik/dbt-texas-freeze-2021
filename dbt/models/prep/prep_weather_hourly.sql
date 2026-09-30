with hourly_data As (
    select * from {{ref('staging_weather_hourly')}}
),
add_features as (
    select *
    , timestamp::DATE AS date 
    , timestamp::TIME AS time
        , TO_CHAR(timestamp,'HH24:MI') as hour
        , TO_CHAR(timestamp, 'FMmonth') as month_name
        , TO_CHAR(timestamp, 'FMday') as weekday
        , DATE_PART('day', timestamp) as date_day
        , DATE_PART('month', timestamp) as date_month
        , DATE_PART ('year', timestamp) as date_year
        , DATE_PART('week', timestamp) as cw
    FROM hourly_data
),
add_more_features as(
    select*
    ,(CASE
        WHEN time BETWEEN '00:00:00' and '05:59:00' THEN 'night'
        WHEN time BETWEEN '06:00:00' AND '18:00:00' THEN 'day'
    	WHEN time BETWEEN '18:00:00' AND '23:59:00' THEN 'evening'
        END) AS day_part
        FROM add_features
)
select * from add_more_features