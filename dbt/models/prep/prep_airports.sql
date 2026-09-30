with reorder as (
SELECT faa, name, city, country, region, lat, lon, alt, tz, dst 
FROM {{ref('staging_airports')}})
select * from reorder