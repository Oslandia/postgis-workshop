7 - Analysis
============

Intersection
------------

Retrieving all administrative area crossed by a single river, ordered from first to last

```SQL
WITH river AS 
(
  SELECT geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river
)

SELECT nom_comm  
FROM admin.commune AS c, river AS r 
WHERE ST_Intersects(c.geom, r.geom)
ORDER BY ST_Line_Locate_Point(ST_LineMerge(r.geom), 
                              ST_ClosestPoint(r.geom, (c.geom)))
;
```

Use on the fly reprojection and view it with QGIS DB Manager

```SQL
SELECT  (row_number() OVER ())::integer AS gid,
        ST_Transform(ST_SetSRID(ST_MakePoint(lon, lat), 4326), 2154) AS geom
FROM rff.station
```


EXPLANATIONS:
- spatial references
- http://www.postgis.net/docs/manual-2.0/ST_Transform.html

Generalization
--------------

Generalize data : simplification of geometries.

```SQL
WITH river AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Hydrological code from Rhone river
)

SELECT 1::integer AS gid, ST_Simplify(geom, 250) AS geom
FROM river
```

Practice :
- View it with QGIS DB Manager
- Then slightly change the simplify parameter

EXPLANATIONS:
- Generalization
- Topology issue
- http://www.postgis.net/docs/manual-2.0/ST_Simplify.html

Buffer search
-------------

Retrieve administrative areas located at 50 Km from Toulouse city center

```SQL
WITH toulouse_50km AS
(
  SELECT ST_Buffer(ST_Centroid(geom), 50000) AS geom
  FROM admin.commune
  WHERE nom_comm = 'TOULOUSE'
)

SELECT gid, nom_comm, c.geom 
FROM admin.commune AS c, toulouse_50km AS t
WHERE ST_Intersects(c.geom, t.geom);
```


Same result without a CTE, with also good performances:

```SQL
SELECT gid, nom_comm, geom
FROM admin.commune
WHERE ST_Intersects(geom,
 (SELECT ST_Buffer(ST_Centroid(geom), 50000)
  FROM admin.commune
  WHERE nom_comm = 'TOULOUSE'
 ));
```

Same result but with poor performance because ST_Intersects call a nested function

```SQL
WITH toulouse AS
(
  SELECT ST_Centroid(geom) AS geom
  FROM admin.commune
  WHERE nom_comm = 'TOULOUSE'
)

SELECT gid, nom_comm, c.geom 
FROM admin.commune AS c, toulouse AS t
WHERE ST_Intersects(c.geom, ST_Buffer(t.geom, 50000));
```

Last but not least, use _ST_Dwithin_ function :
```SQL
select
    *
from
    admin.commune as t1
join
    admin.commune as t2
on
    ST_DWithin(t1.geom, ST_Centroid(t2.geom), 50000)
where
    t2.nom_comm = 'TOULOUSE';
```


EXPLANATIONS:
- Consideration on performances based on spatial index and spatial operator

Nearest neighbors
-----------------

Big city are generally located on big river. Find for each big city big the closest rivers

```SQL
SELECT c.nom_comm, 
                c.population * 1000 AS population, 
                r.toponyme, 
                ST_Distance(r.geom, c.geom) AS dist

FROM admin.commune AS c, 
     hydro.cours_eau AS r

WHERE r.classe = '1' -- big river only
AND   r.toponyme IS NOT NULL
AND   (c.population * 1000) > 100000
AND   r.geom && ST_Expand(c.geom, 10000)
ORDER BY r.geom <-> c.geom
```SQL


EXPLANATIONS:
- Bbox and geometry
- Intesection operator &&
- KNN operators <#> and <-> 
