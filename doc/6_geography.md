6 - Geography
=============

Creation
--------

Create a geography from lat / lon text datas 

```SQL
SELECT ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography AS geog
FROM rff.station;
```

Same one viewable in QGIS DBManager:


```SQL
SELECT (row_number() OVER ()) AS gid,
       (ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography)::geometry AS geom
FROM rff.station;
```

EXPLANATIONS:
- geometry vs geography
- geography only for EPSG:4326
- cast 
- DB Manager not (yet) handle geography rightly

Distance
--------

Compute (brute) distance beetween geography

```
WITH station AS (
  SELECT  row_number() OVER() AS id,
	  name, region,
          ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography AS geog
  FROM rff.station
  WHERE region = 'Alsace'
)

SELECT s1.name, 
       s2.name, 
       ST_Distance(s1.geog, s2.geog)

FROM   station AS s1, 
       station AS s2 

WHERE  s1.id > s2.id  -- to avoid to compute dist(a,b) and dist(b,a)
```


EXPLANATIONS
- Distance and measure functions can deal with geography
- Look at distance result if you do not cast to geography


