4 - Geometry accessors
======================

Binary format
-------------

Retrieve geometry as stored in PostGIS

```SQL
SELECT geom 
FROM admin.commune
LIMIT 10;
```


About the query :
- binary storage in hexadecimal format

Readable infos
--------------

Retrieve structure from some geometries

```SQL

SELECT ST_Summary(geom) 
FROM admin.commune
LIMIT 10;
```

TIP: 
- PGAdmin does not display multilines, use psql, copy-paste, or use strings functions

Display data
------------

Now we want to display the data itself in a human readable format 

```SQL
SELECT ST_AsText(geom) 
FROM admin.commune
LIMIT 10;
```

TIP : 
- PGAdmin display does not display anything if the data is too big (use psql instead)

Access data
-----------

```SQL
-- Aggregate a river 
-- retrieve the number of points in the geometry
-- retrieve a specific point among the linestring


WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river
)


SELECT ST_Summary(geom), 
       ST_NumPoints(geom), 
       ST_AsText(ST_PointN(geom, 55)) AS p_55

FROM rhone;
```

About the query :
- What is SQL CTE
- http://www.postgis.net/docs/manual-2.0/ST_Summary.html
- http://www.postgis.net/docs/manual-2.0/ST_NumPoints.html
- http://www.postgis.net/docs/manual-2.0/ST_PointN.html

Get all points
--------------

If we want to retrieve every single point for the river linestring, we need to perform a loop

We will use _generate_series(i, j)_ :
```SQL
select generate_series(1, 55);

select * from generate_series(1, 55);
```


```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river
)
SELECT generate_series(1, ST_NumPoints(geom)) as n
FROM rhone;
```

About the query :
- generate_series loop
- Same as previously but with the loop on each point

Now get the points :

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river

), loop AS (
  SELECT generate_series(1, ST_NumPoints(geom)) AS n
  FROM rhone
)
SELECT n, ST_AsText(ST_PointN(geom, n))
FROM rhone, loop;

```

And finally the query displayable with QGIS and DBManager:

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river

), loop AS (
  SELECT generate_series(1, ST_NumPoints(geom)) AS n
  FROM rhone
)

SELECT n::integer AS gid, ST_PointN(geom, n) AS geom
FROM rhone, loop;
```

The little format that could : GeoJSON
---------------------------------------

Output a geometry to GeoJSON output format 

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river

)

SELECT ST_AsGeoJSON(ST_Transform(geom, 4326), 5) 
FROM rhone;
```

Some more GeoJSON output :

```SQL
select 
    ST_AsGeojson(ST_Collect(ST_Transform(geom, 4326)), 5) 
from (
    select 
        * 
    from 
        admin.commune 
    where 
        code_dept = '69'
) as coms;
```

About the query :
- http://www.postgis.net/docs/manual-2.0/ST_AsGeoJSON.html
- number of decimal digit to use

Practice :
- Test the result : http://geojsonlint.com/
- Display it in OpenLayers demonstration GeoJSON input (link in ST_AsGeoJSON documentation page)
- Display it on GitHub : https://github.com/vpicavet/geojson-samples/blob/master/rhone.geojson

