2 - Basic Analysis
==================

Find populated cities
---------------------

```SQL

-- Retrieve the 100 most dense cities.

SELECT * 
FROM admin.commune 
ORDER BY population / ST_Area(geom) DESC
LIMIT 100;
```


Practice : 
- View the result in QGIS with DbManager plugin

Toulouse neighbors
-------------------

Retrieve all city located around a single one named Toulouse.

```SQL

SELECT c.gid, c.geom, c.nom_com
FROM admin.commune AS c
WHERE ST_Touches( c.geom, 
                  (SELECT geom FROM admin.commune WHERE nom_com = 'TOULOUSE')
                )
;
```
Practice : 
- View the result in QGIS with DbManager plugin

Longest rivers
--------------

Which rivers are the longest ?
 
```SQL

SELECT SUM(ST_Length(geom)), toponyme
FROM hydro.cours_eau
WHERE toponyme IS NOT NULL
GROUP BY toponyme
ORDER BY SUM(ST_Length(geom)) DESC
LIMIT 10;
```

NOTE: 
- first result is related to data uncompletness

About the query :
- NULL / NOT NULL
- GROUP BY and aggregate function as SUM
- ORDER BY ASC / DESC
- LIMIT

Buffers
-------

```SQL

SELECT ST_Buffer(geom, 10000) AS geom, gid from admin.commune where nom_com = 'TOULOUSE';

```
Make some more buffers around some cities. Then around the cities touching Toulouse.

Distances
---------

-- How far are big cities from Toulouse ?

```SQL

SELECT nom_com,
       population AS population,
       ST_Distance(geom, (SELECT geom FROM admin.commune WHERE nom_com = 'TOULOUSE')) / 1000 AS dist_km
FROM admin.commune
WHERE population > 150000
AND NOT nom_com = 'TOULOUSE';
```

About the query :
- SQL Sub Query
- ST_Distance
