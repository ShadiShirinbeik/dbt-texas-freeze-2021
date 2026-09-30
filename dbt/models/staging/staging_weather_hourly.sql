WITH hourly_raw AS (
					SELECT airport_code
							,station_id
							,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') AS json_data
					FROM {{source('weather_data', 'weather_hourly_raw')}}		
),
hourly_flattened AS (
					SELECT airport_code
							,station_id
							,(json_data ->> 'time')::TIMESTAMP AS timestamp
							,(json_data ->> 'temp')::NUMERIC AS temp_c
							,(json_data ->> 'dwpt')::NUMERIC AS dewpoint_c
							,(json_data ->> 'rhum')::NUMERIC AS humidity_perc
							,(json_data ->> 'prcp')::NUMERIC AS precipitation_mm
							,(json_data ->> 'snow')::NUMERIC::INTEGER AS snow_mm
							,(json_data ->> 'wdir')::NUMERIC::INTEGER AS wind_direction
							,(json_data ->> 'wspd')::NUMERIC AS wind_speed_kmh
							,(json_data ->> 'wpgt')::NUMERIC AS wind_peakgust_kmh
							,(json_data ->> 'pres')::NUMERIC AS pressure_hpa
							,(json_data ->> 'tsun')::NUMERIC::INTEGER AS sun_minutes
                            ,(json_data ->> 'coco')::NUMERIC::INTEGER AS condition_code
						FROM hourly_raw
)
SELECT * FROM hourly_flattened



/*
time	Time (YYYY-MM-DD hh:mm:ss) of observation	String
temp	The air temperature in °C	Float
dwpt	The dew point in °C	Float
rhum	The relative humidity in percent (%)	Integer
prcp	The one hour precipitation total in mm	Float
snow	The snow depth in mm	Integer
wdir	The wind direction in degrees (°)	Integer
wspd	The average wind speed in km/h	Float
wpgt	The peak wind gust in km/h	Float
pres	The sea-level air pressure in hPa	Float
tsun	The one hour sunshine total in minutes (m)	Integer
coco	The weather condition code	Integer */