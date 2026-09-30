with preparation as (
    select  a.name as airport_name
        , a.city
        , a.alt as airport_altitude
        , f.*
    from {{ref('prep_flights')}} as f
    join {{ref('prep_airports')}} a 
    on f.origin = a.faa)
select * from preparation