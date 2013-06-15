5 - Geometry construction
=========================

Geometry cast
-------------

Create a geometry with a simple geometry CAST

```SQL
SELECT ST_AsText('POINT(10 10)'::geometry);
```


About the query :
- cast
- OGC WKT syntax 

WKT + SRID
----------

Same as previously but handle SRID

```SQL
SELECT ST_AsEWKT('SRID=4326;POINT(10 10)'::geometry);
```

Same with an alternate syntax
```SQL
SELECT ST_AsEWKT(ST_SetSRID('POINT(10 10)'::geometry, 4326));
```


About the query :
- SRID
- http://www.postgis.net/docs/manual-2.0/ST_SRID.html
- http://www.postgis.net/docs/manual-2.0/ST_SetSRID.html

Coordinates to geom
-------------------

Create a geometry from lat / lon text datas 
 
```SQL
SELECT ST_SetSRID(ST_MakePoint(lon, lat), 4326) AS geom
FROM rff.station;
```

Same one viewable in QGIS DBManager:

```SQL
SELECT (row_number() OVER ()) AS gid,
       ST_SetSRID(ST_MakePoint(lon, lat), 4326) AS geom
FROM rff.station;
```

About the query :
- http://www.postgis.net/docs/manual-2.0/ST_MakePoint.html
- http://www.postgis.net/docs/manual-2.0/ST_SetSRID.html
