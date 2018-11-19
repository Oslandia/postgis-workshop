4 - Accesseurs de géométries
============================

Format binaire
--------------

Récupérons la géométrie telle que stockée par PostGIS

```SQL
SELECT geom 
FROM admin.commune
LIMIT 10;
```


A propos de la requête :

- stockage binaire en hexadécimal

Informations lisibles
---------------------

Récupérons des informations (structure) sur les géometries

```SQL

SELECT ST_Summary(geom) 
FROM admin.commune
LIMIT 10;
```


Affichons les données
---------------------

On veut à présent afficher la donnée de manière lisible (par un humain)


```SQL
SELECT ST_AsText(geom) 
FROM admin.commune
LIMIT 10;
```

Conseil : 
- PGAdmin a parfois du mal à afficher la données si elle est trop lourde (préférez psql pour ça)

Accès à la donnée
-----------------

```SQL
-- Agrégeons une rivière
-- Récupérons le nombre de points de la géométrie
-- Récupérons un point spécifique dans la géométrie


WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone
)


SELECT ST_Summary(geom), 
       ST_NumPoints(geom), 
       ST_AsText(ST_PointN(geom, 55)) AS p_55

FROM rhone;
```

A propos de la requête :

- Qu'est-ce qu'une CTE
- http://www.postgis.net/docs/manual-2.0/ST_Summary.html
- http://www.postgis.net/docs/manual-2.0/ST_NumPoints.html
- http://www.postgis.net/docs/manual-2.0/ST_PointN.html

Récupération de tous les points
-------------------------------

Si on veut récupérer tous les points du linéaire de la rivière, il faut utiliser une boucle

On va utiliser _generate_series(i, j)_ :


```SQL
select generate_series(1, 55);

select * from generate_series(1, 55);
```


```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone
)
SELECT generate_series(1, ST_NumPoints(geom)) as n
FROM rhone;
```

A propos de la requête :

- boucle generate_series
- Idem que précédement avec une boucle sur chaque point

A présent, récupérons les points :

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone

), loop AS (
  SELECT generate_series(1, ST_NumPoints(geom)) AS n
  FROM rhone
)
SELECT n, ST_AsText(ST_PointN(geom, n))
FROM rhone, loop;

```

Enfin, la requête pour afficher les données dans QGIS:

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone

), loop AS (
  SELECT generate_series(1, ST_NumPoints(geom)) AS n
  FROM rhone
)

SELECT n::integer AS gid, ST_PointN(geom, n) AS geom
FROM rhone, loop;
```

On pourrait utiliser le format GeoJSON
--------------------------------------

Afficher une géométrie au format GeoJSON

```SQL
WITH rhone AS 
(
  SELECT ST_LineMerge(ST_CollectionExtract(ST_Collect(geom), 2)) AS geom 
  FROM hydro.cours_eau 
  WHERE code_hydro = 'V---0000'  -- Code hydrologique du Rhone

)

SELECT substring(ST_AsGeoJSON(ST_Transform(geom, 4326), 5) from 1 for 300)
FROM rhone;
```

Autre affichage en GeoJSON :

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

A propos de la requête :
- http://www.postgis.net/docs/manual-2.0/ST_AsGeoJSON.html
- Nombre de décimales a utiliser

Exercices :
- Testez les résultats sur ce site : http://geojsonlint.com/
- Affichez les résultats sur une carte en utilisant par exemple : http://geojson.io

