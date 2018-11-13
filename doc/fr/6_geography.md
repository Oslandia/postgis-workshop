6 - Geography
=============

Création
--------

Créons une géographie (type geography) à partir de longitudes et latitudes :


```SQL
SELECT ST_SetSRID(ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326)::geography AS geog
FROM rff.station;
```

Pour un affichage sous QGIS :


```SQL
SELECT (row_number() OVER ()) AS gid,
       (ST_SetSRID(ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326)::geography)::geometry AS geom
FROM rff.station;
```

A propos de la requête :
- geometry vs geography
- geography only for EPSG:4326
- cast 
- DB Manager not (yet) handle geography rightly

Distance
--------

Calculons des distances entre geography :

```
WITH station AS (
  SELECT  row_number() OVER() AS id,
	  nom, dept,
          ST_SetSRID(ST_MakePoint(longitude_wgs84, latitude_wgs84), 4326)::geography AS geog
  FROM rff.station
  WHERE dept = 77
)

SELECT s1.nom, 
       s2.nom, 
       ST_Distance(s1.geog, s2.geog)

FROM   station AS s1, 
       station AS s2 

WHERE  s1.id > s2.id;  -- pour éviter de calculer les doublons: dist(a,b) et dist(b,a)
```


A propos de la requête :

- Les fonctions de distance et mesure fonctionnent avec le type geography
- Observez les résultats de distance si vous ne convertissez pas en geography


