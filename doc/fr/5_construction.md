5 - Construction de géometries
==============================

Conversion de geométrie
-----------------------

Créons une géométrie à l'aide d'un CAST :

```SQL
SELECT ST_AsText('POINT(10 10)'::geometry);
```


A propos de la requête :
- cast
- Syntaxe OGC WKT

WKT + SRID
----------

Idem que précédement mais en incluant le SRID :

```SQL
SELECT ST_AsEWKT('SRID=4326;POINT(10 10)'::geometry);
```

La même chose avec une syntaxe alternative :

```SQL
SELECT ST_AsEWKT(ST_SetSRID('POINT(10 10)'::geometry, 4326));
```


A propos de la requête :
- SRID
- http://www.postgis.net/docs/manual-2.0/ST_SRID.html
- http://www.postgis.net/docs/manual-2.0/ST_SetSRID.html

Coordonnées vers géométrie
--------------------------

Créons une géométrie à partir de longitudes et latitudes :

 
```SQL
SELECT ST_SetSRID(ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326) AS geom
FROM rff.station;
```

La même chose en incluant un identifiant pour visualiser la donnée sous QGIS :


```SQL
SELECT (row_number() OVER ()) AS gid,
       ST_SetSRID(ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326) AS geom
FROM rff.station;
```

Autre façon de faire :

```SQL
SELECT (row_number() OVER ()) AS gid,
       ('SRID=4326; POINT('||longitude_wgs84||' '||latitude_wgs84||')')::geometry AS geom
FROM rff.station;
```

A propos de la requête :

- http://www.postgis.net/docs/manual-2.0/ST_MakePoint.html
- http://www.postgis.net/docs/manual-2.0/ST_SetSRID.html

